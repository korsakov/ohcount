fortranfree	comment	! -*- F90 -*-
fortranfree	comment	!     Just a comment, whee.
fortranfree	code	      program foofree
fortranfree	code	      integer:: c
fortranfree	blank	
fortranfree	comment	!     Many languages seem to count split lines as multiple lines,
fortranfree	comment	!     so we should, too.
fortranfree	code	      write (*,*) 1 &
fortranfree	code	     & + 1
fortranfree	blank	
fortranfree	code	C = 1 ! Not a comment.
fortranfree	blank	
fortranfree	comment	! And I've never seen Fortran code that wraps strings; I'm
fortranfree	comment	! not even sure fixed form allows it.
fortranfree	code	      write (*,*) 'But we might as well test for it in&
fortranfree	code	                  & free format.'
fortranfree	blank	
fortranfree	code	end
