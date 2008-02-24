C     Just a comment, whee.
      program foo

C     Many languages seem to count split lines as multiple lines,
C     so we should, too.
      write (*,*) 1
     + + 1

C     And I've never seen Fortran code that wraps strings; I'm
C     not even sure fixed form allows it.
      write (*,*) 'So we don''t bother testing odd string foo.'
      end
