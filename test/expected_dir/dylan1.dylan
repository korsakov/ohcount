dylan	comment	// random program i found
dylan	code	define function describe-list(my-list :: <list>, #key verbose?) => ()
dylan	code	  format(*standard-output*, "{a <list>, size: %d", my-list.size);
dylan	code	  if (verbose?)
dylan	code	    format(*standard-output*, ", elements:");
dylan	code	    for (item in my-list)
dylan	code	      format(*standard-output*, " %=", item);
dylan	code	    end for;
dylan	code	  end if;
dylan	code	  format(*standard-output*, "}");
dylan	code	end function;
dylan	blank	
dylan	code	describe-list(#(1, 2, 3, 4, 5, 6));
dylan	comment	// prints "{a <list>, size: 6}"
dylan	blank	
dylan	code	describe-list(#(5, 7, 3), verbose?: #t);
dylan	comment	// prints "{a <list>, size: 3, elements: 5 7 3}"
