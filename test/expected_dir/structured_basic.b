structured_basic	code	INPUT "What is your name: "; U$
structured_basic	code	PRINT "Hello "; U$
structured_basic	comment	REM Test
structured_basic	code	INPUT "How many stars do you want: "; N
structured_basic	code	S$ = ""
structured_basic	code	FOR I = 1 TO N
structured_basic	code	S$ = S$ + "*"
structured_basic	code	NEXT I
structured_basic	code	PRINT S$
structured_basic	blank	
structured_basic	comment	REM
structured_basic	code	INPUT "Do you want more stars? "; A$
structured_basic	code	IF LEN(A$) = 0 THEN GOTO 110
structured_basic	code	A$ = LEFT$(A$, 1)
structured_basic	code	IF (A$ = "Y") OR (A$ = "y") THEN GOTO 40
structured_basic	code	PRINT "Goodbye ";
structured_basic	code	FOR I = 1 TO 200
structured_basic	code	PRINT U$; " ";
structured_basic	code	NEXT I
structured_basic	code	PRINT
