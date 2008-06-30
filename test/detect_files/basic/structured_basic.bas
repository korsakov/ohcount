INPUT "What is your name: "; U$
PRINT "Hello "; U$
REM Test
INPUT "How many stars do you want: "; N
S$ = ""
FOR I = 1 TO N
S$ = S$ + "*"
NEXT I
PRINT S$

REM
INPUT "Do you want more stars? "; A$
IF LEN(A$) = 0 THEN GOTO 110
A$ = LEFT$(A$, 1)
IF (A$ = "Y") OR (A$ = "y") THEN GOTO 40
PRINT "Goodbye ";
FOR I = 1 TO 200
PRINT U$; " ";
NEXT I
PRINT
