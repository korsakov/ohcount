lisp	comment	;;; CrapsSim.lsp
lisp	blank	
lisp	comment	"""
lisp	comment	The main purpose of this program was to implement a Craps game, using a language that we have just
lisp	comment	learned.  Also, it was written in a functional style with almost no reliance on the assignment
lisp	comment	operation.  Only one local variable called THROW was used.
lisp	comment	"""
lisp	blank	
lisp	blank	
lisp	comment	;;; ====================================================================================================== ;;;
lisp	comment	;;; ======================================= CRAPS SIMULATION ============================================= ;;;
lisp	comment	;;; ====================================================================================================== ;;;
lisp	blank	
lisp	blank	
lisp	comment	;;; ** This function takes no parameters as input and returns a random number between 1 and 6. **
lisp	blank	
lisp	code	(DEFUN THROW-DIE ()
lisp	code				 (+ (RANDOM 6) 1)          ;;; get a random number between 0 and 5 and then add 1
lisp	code				 )
lisp	blank	
lisp	comment	;;; ====================================================================================================== ;;;
lisp	blank	
lisp	comment	;;; ** This function takes no parameters as input and returns a LIST with two numbers between 1 and 6. **
lisp	blank	
lisp	blank	
lisp	code	(DEFUN THROW-DICE ()       
lisp	blank	
lisp	code				 (LIST (THROW-DIE) (THROW-DIE))              ;;; create a list with two random numbers
lisp	blank	
lisp	code				 )
lisp	blank	
lisp	comment	;;; ====================================================================================================== ;;;
lisp	blank	
lisp	comment	;;; ** This function takes two numbers as parameters for input and returns T or Nil.  T is returned if both
lisp	comment	;;;    numbers are equal to 6.  Nil is returned otherwise. **
lisp	blank	
lisp	code	(DEFUN BOXCARS-P (A B)
lisp	code				 (AND (EQUAL '6 A)                      
lisp	code							(EQUAL '6 B)
lisp	code							)
lisp	blank	
lisp	code				 )
lisp	blank	
lisp	comment	;;; ====================================================================================================== ;;;
lisp	blank	
lisp	comment	;;; ** This function takes two numbers as parameters for input and returns T or Nil.  T is returned if both
lisp	comment	;;;    numbers are equal to 1.  Nil is returned otherwise. **
lisp	blank	
lisp	code	(DEFUN SNAKE-EYES-P (A B)
lisp	code				 (AND (EQUAL '1 A)                       
lisp	code							(EQUAL '1 B)
lisp	code							)
lisp	blank	
lisp	code				 )
lisp	blank	
lisp	comment	;;; ====================================================================================================== ;;;
lisp	blank	
lisp	comment	;;; ** This function takes two numbers as parameters for input and returns T or Nil.  T is returned if the 
lisp	comment	;;;    sum of both numbers is equal to a 7 or 11.  Nil is returned otherwise. **
lisp	blank	
lisp	code	(DEFUN INSTANT-WIN-P (A B)
lisp	code				 (OR (EQUAL '7 (+ A B))                  
lisp	code						 (EQUAL '11 (+ A B))
lisp	code						 )
lisp	blank	
lisp	code				 )
lisp	blank	
lisp	comment	;;; ====================================================================================================== ;;;
lisp	blank	
lisp	comment	;;; ** This function takes two numbers as parameters for input and returns T or Nil.  T is returned if the 
lisp	comment	;;;    sum of both numbers is equal to a 2, 3 or 12.  Nil is returned otherwise. **
lisp	blank	
lisp	code	(DEFUN INSTANT-LOSS-P (A B)
lisp	code				 (OR (EQUAL '2 (+ A B))
lisp	code						 (EQUAL '3 (+ A B))
lisp	code						 (EQUAL '12 (+ A B))
lisp	code						 )
lisp	blank	
lisp	code				 )
lisp	blank	
lisp	comment	;;; ====================================================================================================== ;;;
lisp	blank	
lisp	comment	;;; ** This function takes two numbers as parameters for input and returns a string.  If function BOXCARS_P
lisp	comment	;;;    returns T, then the returned string equals BOXCARS.  If function SNAKE_EYES_P returns T, then the 
lisp	comment	;;;    returned string equals SNAKE_EYES.  The string contains Nil otherwise. **
lisp	blank	
lisp	code	(DEFUN SAY-THROW (A B)
lisp	code				 (COND ((BOXCARS-P A B) 'BOXCARS)                 ;;; make use of function BOXCARS_P
lisp	code							 ((SNAKE-EYES-P A B) 'SNAKE-EYES)           ;;; make use of function SNAKE_EYES_P
lisp	blank	
lisp	code							 )
lisp	code				 )
lisp	blank	
lisp	comment	;;; ====================================================================================================== ;;;
lisp	blank	
lisp	comment	;;; ** This is the main function used to simulate the game of craps.  Variable THROW contains a LIST of two
lisp	comment	;;;    numbers between 1 and 6.  The numbers located in THROW, are used as parameters for the other functions.
lisp	comment	;;;    The several pieces used for output are listed together and then the LIST is returned from this 
lisp	comment	;;;    function.
lisp	blank	
lisp	blank	
lisp	code	(DEFUN CRAPS ()
lisp	code				 (LET THROW (THROW-DICE))                        ;;; get initial roll of the dice
lisp	blank	
lisp	comment				 ;;; if roll is a win, then LIST the appropriate output
lisp	blank	
lisp	code				 (COND ((INSTANT-WIN-P (FIRST THROW) (SECOND THROW)) 
lisp	code								(LIST 'THROW (FIRST THROW) 'AND (SECOND THROW) '-- (+ (FIRST THROW) (SECOND THROW)) '-- 'YOU 'WIN))
lisp	blank	
lisp	comment							 ;;; if roll is a loss, then check for BOXCARS or SNAKE-EYES
lisp	blank	
lisp	code							 ((INSTANT-LOSS-P (FIRST THROW) (SECOND THROW))
lisp	blank	
lisp	code								(IF (EQUAL 'NIL (SAY-THROW (FIRST THROW) (SECOND THROW)))   ;;; if Nil then LIST appropriate output
lisp	blank	
lisp	code										(LIST 'THROW (FIRST THROW) 'AND (SECOND THROW) '-- (+ (FIRST THROW) (SECOND THROW)) '-- 'YOU 'LOSE)
lisp	blank	
lisp	comment										;;; else include the BOXCARS or SNAKE-EYES string in the output
lisp	blank	
lisp	code										(LIST 'THROW (FIRST THROW) 'AND (SECOND THROW) '-- (SAY-THROW (FIRST THROW) (SECOND THROW)) 
lisp	code													'-- 'YOU 'LOSE)))
lisp	blank	
lisp	comment							 ;;; if roll is not instant win or loss then output sum of dice
lisp	blank	
lisp	code							 (T (LIST 'THROW (FIRST THROW) 'AND (SECOND THROW) '-- 'YOUR 'POINT 'IS (+ (FIRST THROW) 
lisp	code																																												 (SECOND THROW))))
lisp	code							 )        ;;; end COND
lisp	blank	
lisp	code				 )           ;;; end LET
lisp	blank	
lisp	blank	
lisp	code	)
lisp	blank	
lisp	blank	
lisp	comment	;;; ======================================== END OF PROGRAM CRAPS ======================================== ;;;
