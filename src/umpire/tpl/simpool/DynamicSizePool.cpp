#include "umpire/tpl/simpool/DynamicSizePool.hpp"

#include "umpire/util/Macros.hpp"

void DynamicSizePool::findUsableBlock(struct Block *&best, struct Block *&prev, std::size_t size) {
  best = prev = NULL;
  for ( struct Block *iter = freeBlocks, *iterPrev = NULL ; iter ; iter = iter->next ) {
    if ( iter->size >= size && (!best || iter->size < best->size) ) {
      best = iter;
      prev = iterPrev;
      if ( iter->size == size )
        break;    // Exact match, won't find a better one, look no further
    }
    iterPrev = iter;
  }
}

inline static std::size_t alignmentAdjust(const std::size_t size) {
  const std::size_t AlignmentBoundary = 16;
  return std::size_t (size + (AlignmentBoundary-1)) & ~(AlignmentBoundary-1);
}

void DynamicSizePool::allocateBlock(struct Block *&curr, struct Block *&prev, const std::size_t size) {
  std::size_t sizeToAlloc;

  if ( freeBlocks == NULL && usedBlocks == NULL )
    sizeToAlloc = std::max(size, minInitialBytes);
  else
    sizeToAlloc = std::max(size, minBytes);

  curr = prev = NULL;
  void *data = NULL;

  // Allocate data
  try {
    data = allocator->allocate(sizeToAlloc);
  }
  catch (...) {
    UMPIRE_LOG(Error,
               "\n\tMemory exhausted at allocation resource. "
               "Attempting to give blocks back.\n\t"
               << getCurrentSize() << " Allocated to pool, "
               << getFreeBlocks() << " Free Blocks, "
               << getInUseBlocks() << " Used Blocks\n"
      );
    freeReleasedBlocks();
    UMPIRE_LOG(Error,
               "\n\tMemory exhausted at allocation resource.  "
               "\n\tRetrying allocation operation: "
               << getCurrentSize() << " Bytes still allocated to pool, "
               << getFreeBlocks() << " Free Blocks, "
               << getInUseBlocks() << " Used Blocks\n"
      );
    try {
      data = allocator->allocate(sizeToAlloc);
      UMPIRE_LOG(Error,
                 "\n\tMemory successfully recovered at resource.  Allocation succeeded\n"
        );
    }
    catch (...) {
      UMPIRE_LOG(Error,
                 "\n\tUnable to allocate from resource even after giving back free blocks.\n"
                 "\tThrowing to let application know we have no more memory: "
                 << getCurrentSize() << " Bytes still allocated to pool\n"
                 << getFreeBlocks() << " Partially Free Blocks, "
                 << getInUseBlocks() << " Used Blocks\n"
        );
      throw;
    }
  }

  totalBlocks += 1;
  totalBytes += sizeToAlloc;

  // Allocate the block
  curr = (struct Block *) blockPool.allocate();
  assert("Failed to allocate block for freeBlock List" && curr);

  // Find next and prev such that next->data is still smaller than data (keep ordered)
  struct Block *next;
  for ( next = freeBlocks; next && next->data < data; next = next->next )
    prev = next;

  // Insert
  curr->data = static_cast<char *>(data);
  curr->size = sizeToAlloc;
  curr->blockSize = sizeToAlloc;
  curr->next = next;

  // Insert
  if (prev) prev->next = curr;
  else freeBlocks = curr;
}

void DynamicSizePool::splitBlock(struct Block *&curr, struct Block *&prev, const std::size_t size) {
  struct Block *next;

  if ( curr->size == size ) {
    // Keep it
    next = curr->next;
  }
  else {
    // Split the block
    std::size_t remaining = curr->size - size;
    struct Block *newBlock = (struct Block *) blockPool.allocate();
    if (!newBlock) return;
    newBlock->data = curr->data + size;
    newBlock->size = remaining;
    newBlock->blockSize = 0;
    newBlock->next = curr->next;
    next = newBlock;
    curr->size = size;
  }

  if (prev) prev->next = next;
  else freeBlocks = next;
}

void DynamicSizePool::releaseBlock(struct Block *curr, struct Block *prev) {
  assert(curr != NULL);

  if (prev) prev->next = curr->next;
  else usedBlocks = curr->next;

  // Find location to put this block in the freeBlocks list
  prev = NULL;
  for ( struct Block *temp = freeBlocks ; temp && temp->data < curr->data ; temp = temp->next )
    prev = temp;

  // Keep track of the successor
  struct Block *next = prev ? prev->next : freeBlocks;

  // Check if prev and curr can be merged
  if ( prev && prev->data + prev->size == curr->data && !curr->blockSize ) {
    prev->size = prev->size + curr->size;
    blockPool.deallocate(curr); // keep data
    curr = prev;
  }
  else if (prev) {
    prev->next = curr;
  }
  else {
    freeBlocks = curr;
  }

  // Check if curr and next can be merged
  if ( next && curr->data + curr->size == next->data && !next->blockSize ) {
    curr->size = curr->size + next->size;
    curr->next = next->next;
    blockPool.deallocate(next); // keep data
  }
  else {
    curr->next = next;
  }
}

std::size_t DynamicSizePool::freeReleasedBlocks() {
  // Release the unused blocks
  struct Block *curr = freeBlocks;
  struct Block *prev = NULL;

  std::size_t freed = 0;

  while ( curr ) {
    struct Block *next = curr->next;
    // The free block list may contain partially released released blocks.
    // Make sure to only free blocks that are completely released.
    //
    if ( curr->size == curr->blockSize ) {
      totalBlocks -= 1;
      totalBytes -= curr->blockSize;
      freed += curr->blockSize;
      allocator->deallocate(curr->data);

      if ( prev )   prev->next = curr->next;
      else          freeBlocks = curr->next;

      blockPool.deallocate(curr);
    }
    else {
      prev = curr;
    }
    curr = next;
  }

  return freed;
}

void DynamicSizePool::coalesceFreeBlocks(std::size_t size) {
  UMPIRE_LOG(Debug, "Allocator " << this
             << " coalescing to "
             << size << " bytes from "
             << getFreeBlocks() << " free blocks\n");
  freeReleasedBlocks();
  void* ptr = allocate(size);
  deallocate(ptr);
}

void DynamicSizePool::freeAllBlocks() {
  // Release the used blocks
  while(usedBlocks) {
    releaseBlock(usedBlocks, NULL);
  }

  freeReleasedBlocks();
  UMPIRE_ASSERT("Not all blocks were released properly" && freeBlocks == NULL );
}

DynamicSizePool::DynamicSizePool(
  umpire::strategy::AllocationStrategy* strat,
  const std::size_t _minInitialBytes,
  const std::size_t _minBytes) :
  blockPool(sizeof(struct Block)),
  usedBlocks(nullptr),
  freeBlocks(nullptr),
  totalBlocks(0),
  totalBytes(0),
  allocBytes(0),
  minInitialBytes(_minInitialBytes),
  minBytes(_minBytes),
  highWatermark(0),
  allocator(strat)
{
}

DynamicSizePool::~DynamicSizePool() { freeAllBlocks(); }

void* DynamicSizePool::allocate(std::size_t size) {
  struct Block *best, *prev;
  size = alignmentAdjust(size);
  findUsableBlock(best, prev, size);

  // Allocate a block if needed
  if (!best) allocateBlock(best, prev, size);
  assert(best);

  // Split the free block
  splitBlock(best, prev, size);

  // Push node to the list of used nodes
  best->next = usedBlocks;
  usedBlocks = best;

  // Increment the allocated size
  allocBytes += size;

  if ( allocBytes > highWatermark )
    highWatermark = allocBytes;

  // Return the new pointer
  return usedBlocks->data;
}

void DynamicSizePool::deallocate(void *ptr) {
  assert(ptr);

  // Find the associated block
  struct Block *curr = usedBlocks, *prev = NULL;
  for ( ; curr && curr->data != ptr; curr = curr->next ) {
    prev = curr;
  }
  if (!curr) return;

  // Remove from allocBytes
  allocBytes -= curr->size;

  // Release it
  releaseBlock(curr, prev);
}

std::size_t DynamicSizePool::getCurrentSize() const
{
  return allocBytes;
}

std::size_t DynamicSizePool::getActualSize() const
{
  return totalBytes;
}

std::size_t DynamicSizePool::getHighWatermark() const
{
  return highWatermark;
}

std::size_t DynamicSizePool::getBlocksInPool() const
{
  return totalBlocks;
}

std::size_t DynamicSizePool::getReleasableSize() const
{
  std::size_t nblocks = 0;
  std::size_t nbytes = 0;
  for (struct Block *temp = freeBlocks; temp; temp = temp->next) {
    if ( temp->size == temp->blockSize ) {
      nbytes += temp->blockSize;
      nblocks++;
    }
  }
  return nblocks > 1 ? nbytes : 0;
}

std::size_t DynamicSizePool::getFreeBlocks() const
{
  std::size_t nb = 0;
  for (struct Block *temp = freeBlocks; temp; temp = temp->next)
    if ( temp->size == temp->blockSize )
      nb++;
  return nb;
}

std::size_t DynamicSizePool::getInUseBlocks() const
{
  std::size_t nb = 0;
  for (struct Block *temp = usedBlocks; temp; temp = temp->next) nb++;
  return nb;
}

void DynamicSizePool::coalesce()
{
  if ( getFreeBlocks() > 1 ) {
    std::size_t size_to_coalesce = freeReleasedBlocks();

    UMPIRE_LOG(Debug, "Attempting to coalesce "
               << size_to_coalesce << " bytes");

    coalesceFreeBlocks(size_to_coalesce);
  }
}

void DynamicSizePool::release()
{
  freeReleasedBlocks();
}
