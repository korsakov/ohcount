! -*- F90 -*-
      program fortranfreecheck
!     Simple check.  Not valid fixed form thanks to the continuation.
      write(*,*) 2 + &
& 2
      goto 22
 22   write(*,*) 'bar'
      end
