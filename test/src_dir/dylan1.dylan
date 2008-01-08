// random program i found
define function describe-list(my-list :: <list>, #key verbose?) => ()
  format(*standard-output*, "{a <list>, size: %d", my-list.size);
  if (verbose?)
    format(*standard-output*, ", elements:");
    for (item in my-list)
      format(*standard-output*, " %=", item);
    end for;
  end if;
  format(*standard-output*, "}");
end function;
    
describe-list(#(1, 2, 3, 4, 5, 6));
// prints "{a <list>, size: 6}"

describe-list(#(5, 7, 3), verbose?: #t);
// prints "{a <list>, size: 3, elements: 5 7 3}"
