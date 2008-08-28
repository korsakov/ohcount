fortranfixed	comment	C     Just a comment, whee.
fortranfixed	code	      program foo
fortranfixed	blank	
fortranfixed	comment	C     Many languages seem to count split lines as multiple lines,
fortranfixed	comment	C     so we should, too.
fortranfixed	code	      write (*,*) 1
fortranfixed	code	     + + 1
fortranfixed	blank	
fortranfixed	comment	C     And I've never seen Fortran code that wraps strings; I'm
fortranfixed	comment	C     not even sure fixed form allows it.
fortranfixed	code	      write (*,*) 'So we don''t bother testing odd string foo.'
fortranfixed	code	      end
