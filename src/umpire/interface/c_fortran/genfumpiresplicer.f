! Generated by genfumpiresplicer.py
!
! Copyright (c) 2016-20, Lawrence Livermore National Security, LLC and Umpire
! project contributors. See the COPYRIGHT file for details.
!
! SPDX-License-Identifier: (MIT)
!


! splicer begin class.Allocator.type_bound_procedure_part

procedure :: allocate_int_array_1d => allocator_allocate_int_array_1d
procedure :: deallocate_int_array_1d => allocator_deallocate_int_array_1d
procedure :: allocate_int_array_2d => allocator_allocate_int_array_2d
procedure :: deallocate_int_array_2d => allocator_deallocate_int_array_2d
procedure :: allocate_int_array_3d => allocator_allocate_int_array_3d
procedure :: deallocate_int_array_3d => allocator_deallocate_int_array_3d
procedure :: allocate_int_array_4d => allocator_allocate_int_array_4d
procedure :: deallocate_int_array_4d => allocator_deallocate_int_array_4d
procedure :: allocate_long_array_1d => allocator_allocate_long_array_1d
procedure :: deallocate_long_array_1d => allocator_deallocate_long_array_1d
procedure :: allocate_long_array_2d => allocator_allocate_long_array_2d
procedure :: deallocate_long_array_2d => allocator_deallocate_long_array_2d
procedure :: allocate_long_array_3d => allocator_allocate_long_array_3d
procedure :: deallocate_long_array_3d => allocator_deallocate_long_array_3d
procedure :: allocate_long_array_4d => allocator_allocate_long_array_4d
procedure :: deallocate_long_array_4d => allocator_deallocate_long_array_4d
procedure :: allocate_float_array_1d => allocator_allocate_float_array_1d
procedure :: deallocate_float_array_1d => allocator_deallocate_float_array_1d
procedure :: allocate_float_array_2d => allocator_allocate_float_array_2d
procedure :: deallocate_float_array_2d => allocator_deallocate_float_array_2d
procedure :: allocate_float_array_3d => allocator_allocate_float_array_3d
procedure :: deallocate_float_array_3d => allocator_deallocate_float_array_3d
procedure :: allocate_float_array_4d => allocator_allocate_float_array_4d
procedure :: deallocate_float_array_4d => allocator_deallocate_float_array_4d
procedure :: allocate_double_array_1d => allocator_allocate_double_array_1d
procedure :: deallocate_double_array_1d => allocator_deallocate_double_array_1d
procedure :: allocate_double_array_2d => allocator_allocate_double_array_2d
procedure :: deallocate_double_array_2d => allocator_deallocate_double_array_2d
procedure :: allocate_double_array_3d => allocator_allocate_double_array_3d
procedure :: deallocate_double_array_3d => allocator_deallocate_double_array_3d
procedure :: allocate_double_array_4d => allocator_allocate_double_array_4d
procedure :: deallocate_double_array_4d => allocator_deallocate_double_array_4d
generic, public :: allocate => &
    allocate_int_array_1d, &
    allocate_int_array_2d, &
    allocate_int_array_3d, &
    allocate_int_array_4d, &
    allocate_long_array_1d, &
    allocate_long_array_2d, &
    allocate_long_array_3d, &
    allocate_long_array_4d, &
    allocate_float_array_1d, &
    allocate_float_array_2d, &
    allocate_float_array_3d, &
    allocate_float_array_4d, &
    allocate_double_array_1d, &
    allocate_double_array_2d, &
    allocate_double_array_3d, &
    allocate_double_array_4d

generic, public :: deallocate => &
    deallocate_int_array_1d, &
    deallocate_int_array_2d, &
    deallocate_int_array_3d, &
    deallocate_int_array_4d, &
    deallocate_long_array_1d, &
    deallocate_long_array_2d, &
    deallocate_long_array_3d, &
    deallocate_long_array_4d, &
    deallocate_float_array_1d, &
    deallocate_float_array_2d, &
    deallocate_float_array_3d, &
    deallocate_float_array_4d, &
    deallocate_double_array_1d, &
    deallocate_double_array_2d, &
    deallocate_double_array_3d, &
    deallocate_double_array_4d

! splicer end class.Allocator.type_bound_procedure_part

! splicer begin class.Allocator.additional_functions


subroutine allocator_allocate_int_array_1d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_INT), intent(inout), pointer, dimension(:) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      integer(C_INT) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_int_array_1d



subroutine allocator_deallocate_int_array_1d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_INT), intent(inout), pointer, dimension(:) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_int_array_1d



subroutine allocator_allocate_int_array_2d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_INT), intent(inout), pointer, dimension(:, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      integer(C_INT) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_int_array_2d



subroutine allocator_deallocate_int_array_2d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_INT), intent(inout), pointer, dimension(:, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_int_array_2d



subroutine allocator_allocate_int_array_3d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_INT), intent(inout), pointer, dimension(:, :, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      integer(C_INT) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_int_array_3d



subroutine allocator_deallocate_int_array_3d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_INT), intent(inout), pointer, dimension(:, :, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_int_array_3d



subroutine allocator_allocate_int_array_4d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_INT), intent(inout), pointer, dimension(:, :, :, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      integer(C_INT) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_int_array_4d



subroutine allocator_deallocate_int_array_4d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_INT), intent(inout), pointer, dimension(:, :, :, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_int_array_4d



subroutine allocator_allocate_long_array_1d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_LONG), intent(inout), pointer, dimension(:) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      integer(C_LONG) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_long_array_1d



subroutine allocator_deallocate_long_array_1d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_LONG), intent(inout), pointer, dimension(:) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_long_array_1d



subroutine allocator_allocate_long_array_2d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_LONG), intent(inout), pointer, dimension(:, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      integer(C_LONG) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_long_array_2d



subroutine allocator_deallocate_long_array_2d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_LONG), intent(inout), pointer, dimension(:, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_long_array_2d



subroutine allocator_allocate_long_array_3d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_LONG), intent(inout), pointer, dimension(:, :, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      integer(C_LONG) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_long_array_3d



subroutine allocator_deallocate_long_array_3d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_LONG), intent(inout), pointer, dimension(:, :, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_long_array_3d



subroutine allocator_allocate_long_array_4d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_LONG), intent(inout), pointer, dimension(:, :, :, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      integer(C_LONG) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_long_array_4d



subroutine allocator_deallocate_long_array_4d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      integer(C_LONG), intent(inout), pointer, dimension(:, :, :, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_long_array_4d



subroutine allocator_allocate_float_array_1d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_FLOAT), intent(inout), pointer, dimension(:) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      real(C_FLOAT) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_float_array_1d



subroutine allocator_deallocate_float_array_1d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_FLOAT), intent(inout), pointer, dimension(:) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_float_array_1d



subroutine allocator_allocate_float_array_2d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_FLOAT), intent(inout), pointer, dimension(:, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      real(C_FLOAT) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_float_array_2d



subroutine allocator_deallocate_float_array_2d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_FLOAT), intent(inout), pointer, dimension(:, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_float_array_2d



subroutine allocator_allocate_float_array_3d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_FLOAT), intent(inout), pointer, dimension(:, :, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      real(C_FLOAT) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_float_array_3d



subroutine allocator_deallocate_float_array_3d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_FLOAT), intent(inout), pointer, dimension(:, :, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_float_array_3d



subroutine allocator_allocate_float_array_4d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_FLOAT), intent(inout), pointer, dimension(:, :, :, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      real(C_FLOAT) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_float_array_4d



subroutine allocator_deallocate_float_array_4d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_FLOAT), intent(inout), pointer, dimension(:, :, :, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_float_array_4d



subroutine allocator_allocate_double_array_1d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_DOUBLE), intent(inout), pointer, dimension(:) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      real(C_DOUBLE) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_double_array_1d



subroutine allocator_deallocate_double_array_1d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_DOUBLE), intent(inout), pointer, dimension(:) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_double_array_1d



subroutine allocator_allocate_double_array_2d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_DOUBLE), intent(inout), pointer, dimension(:, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      real(C_DOUBLE) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_double_array_2d



subroutine allocator_deallocate_double_array_2d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_DOUBLE), intent(inout), pointer, dimension(:, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_double_array_2d



subroutine allocator_allocate_double_array_3d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_DOUBLE), intent(inout), pointer, dimension(:, :, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      real(C_DOUBLE) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_double_array_3d



subroutine allocator_deallocate_double_array_3d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_DOUBLE), intent(inout), pointer, dimension(:, :, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_double_array_3d



subroutine allocator_allocate_double_array_4d(this, array, dims)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_DOUBLE), intent(inout), pointer, dimension(:, :, :, :) :: array

      integer, dimension(:) :: dims

      type(C_PTR) :: data_ptr

      real(C_DOUBLE) :: size_type
      integer(C_SIZE_T) :: num_bytes

      num_bytes = product(dims) * sizeof(size_type)
      data_ptr = this%allocate_pointer(num_bytes)

      call c_f_pointer(data_ptr, array, dims)
end subroutine allocator_allocate_double_array_4d



subroutine allocator_deallocate_double_array_4d(this, array)
      use iso_c_binding

      class(UmpireAllocator) :: this
      real(C_DOUBLE), intent(inout), pointer, dimension(:, :, :, :) :: array

      type(C_PTR) :: data_ptr

      data_ptr = c_loc(array)

      call this%deallocate_pointer(data_ptr)
      nullify(array)
end subroutine allocator_deallocate_double_array_4d


! splicer end class.Allocator.additional_functions
