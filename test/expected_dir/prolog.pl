prolog	comment	/* test file for Prolog parsing */
prolog	blank	
prolog	comment	% this is a Prolog source file
prolog	blank	
prolog	comment	% select(Element, List, Remaining)
prolog	blank	
prolog	code	select(H, [H| T], T).
prolog	code	select(H, [X| R], [X| T]) :-
prolog	code		select(H, R, T).
