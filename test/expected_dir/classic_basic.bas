classic_basic	code	10 INPUT "What is your name: "; U$
classic_basic	code	20 PRINT "Hello "; U$
classic_basic	comment	30 REM Test
classic_basic	code	40 INPUT "How many stars do you want: "; N
classic_basic	code	50 S$ = ""
classic_basic	code	60 FOR I = 1 TO N
classic_basic	code	70 S$ = S$ + "*"
classic_basic	code	80 NEXT I
classic_basic	code	90 PRINT S$
classic_basic	blank	
classic_basic	comment	100 REM
classic_basic	code	110 INPUT "Do you want more stars? "; A$
classic_basic	code	120 IF LEN(A$) = 0 THEN GOTO 110
classic_basic	code	130 A$ = LEFT$(A$, 1)
classic_basic	code	140 IF (A$ = "Y") OR (A$ = "y") THEN GOTO 40
classic_basic	code	150 PRINT "Goodbye ";
classic_basic	code	160 FOR I = 1 TO 200
classic_basic	code	170 PRINT U$; " ";
classic_basic	code	180 NEXT I
classic_basic	code	190 PRINT
