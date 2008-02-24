      PROGRAM fortranfixedcheck
!     Simple check.  Not valid free-form because of the continuation.
      WRITE(*,*)
     + 'foo'
      GOTO 22
 22   WRITE(*,*) 'bar'
      END
