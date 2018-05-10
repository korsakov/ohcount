/* test file for Prolog parsing */

% this is a Prolog source file

% select(Element, List, Remaining)

select(H, [H| T], T).
select(H, [X| R], [X| T]) :-
	select(H, R, T).
