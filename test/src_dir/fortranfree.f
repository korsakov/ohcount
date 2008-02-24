! -*- F90 -*-
!     Just a comment, whee.
      program foofree
      integer:: c

!     Many languages seem to count split lines as multiple lines,
!     so we should, too.
      write (*,*) 1 &
     & + 1

C = 1 ! Not a comment.

! And I've never seen Fortran code that wraps strings; I'm
! not even sure fixed form allows it.
      write (*,*) 'But we might as well test for it in&
                  & free format.'

end
