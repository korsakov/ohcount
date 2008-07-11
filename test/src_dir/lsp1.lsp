;;; CrapsSim.lsp

"""
The main purpose of this program was to implement a Craps game, using a language that we have just
learned.  Also, it was written in a functional style with almost no reliance on the assignment
operation.  Only one local variable called THROW was used.
"""


;;; ====================================================================================================== ;;;
;;; ======================================= CRAPS SIMULATION ============================================= ;;;
;;; ====================================================================================================== ;;;


;;; ** This function takes no parameters as input and returns a random number between 1 and 6. **

(DEFUN THROW-DIE ()
			 (+ (RANDOM 6) 1)          ;;; get a random number between 0 and 5 and then add 1
			 )

;;; ====================================================================================================== ;;;

;;; ** This function takes no parameters as input and returns a LIST with two numbers between 1 and 6. **


(DEFUN THROW-DICE ()       

			 (LIST (THROW-DIE) (THROW-DIE))              ;;; create a list with two random numbers

			 )

;;; ====================================================================================================== ;;;

;;; ** This function takes two numbers as parameters for input and returns T or Nil.  T is returned if both
;;;    numbers are equal to 6.  Nil is returned otherwise. **

(DEFUN BOXCARS-P (A B)
			 (AND (EQUAL '6 A)                      
						(EQUAL '6 B)
						)

			 )

;;; ====================================================================================================== ;;;

;;; ** This function takes two numbers as parameters for input and returns T or Nil.  T is returned if both
;;;    numbers are equal to 1.  Nil is returned otherwise. **

(DEFUN SNAKE-EYES-P (A B)
			 (AND (EQUAL '1 A)                       
						(EQUAL '1 B)
						)

			 )

;;; ====================================================================================================== ;;;

;;; ** This function takes two numbers as parameters for input and returns T or Nil.  T is returned if the 
;;;    sum of both numbers is equal to a 7 or 11.  Nil is returned otherwise. **

(DEFUN INSTANT-WIN-P (A B)
			 (OR (EQUAL '7 (+ A B))                  
					 (EQUAL '11 (+ A B))
					 )

			 )

;;; ====================================================================================================== ;;;

;;; ** This function takes two numbers as parameters for input and returns T or Nil.  T is returned if the 
;;;    sum of both numbers is equal to a 2, 3 or 12.  Nil is returned otherwise. **

(DEFUN INSTANT-LOSS-P (A B)
			 (OR (EQUAL '2 (+ A B))
					 (EQUAL '3 (+ A B))
					 (EQUAL '12 (+ A B))
					 )

			 )

;;; ====================================================================================================== ;;;

;;; ** This function takes two numbers as parameters for input and returns a string.  If function BOXCARS_P
;;;    returns T, then the returned string equals BOXCARS.  If function SNAKE_EYES_P returns T, then the 
;;;    returned string equals SNAKE_EYES.  The string contains Nil otherwise. **

(DEFUN SAY-THROW (A B)
			 (COND ((BOXCARS-P A B) 'BOXCARS)                 ;;; make use of function BOXCARS_P
						 ((SNAKE-EYES-P A B) 'SNAKE-EYES)           ;;; make use of function SNAKE_EYES_P

						 )
			 )

;;; ====================================================================================================== ;;;

;;; ** This is the main function used to simulate the game of craps.  Variable THROW contains a LIST of two
;;;    numbers between 1 and 6.  The numbers located in THROW, are used as parameters for the other functions.
;;;    The several pieces used for output are listed together and then the LIST is returned from this 
;;;    function.


(DEFUN CRAPS ()
			 (LET THROW (THROW-DICE))                        ;;; get initial roll of the dice

			 ;;; if roll is a win, then LIST the appropriate output

			 (COND ((INSTANT-WIN-P (FIRST THROW) (SECOND THROW)) 
							(LIST 'THROW (FIRST THROW) 'AND (SECOND THROW) '-- (+ (FIRST THROW) (SECOND THROW)) '-- 'YOU 'WIN))

						 ;;; if roll is a loss, then check for BOXCARS or SNAKE-EYES

						 ((INSTANT-LOSS-P (FIRST THROW) (SECOND THROW))

							(IF (EQUAL 'NIL (SAY-THROW (FIRST THROW) (SECOND THROW)))   ;;; if Nil then LIST appropriate output

									(LIST 'THROW (FIRST THROW) 'AND (SECOND THROW) '-- (+ (FIRST THROW) (SECOND THROW)) '-- 'YOU 'LOSE)

									;;; else include the BOXCARS or SNAKE-EYES string in the output

									(LIST 'THROW (FIRST THROW) 'AND (SECOND THROW) '-- (SAY-THROW (FIRST THROW) (SECOND THROW)) 
												'-- 'YOU 'LOSE)))

						 ;;; if roll is not instant win or loss then output sum of dice

						 (T (LIST 'THROW (FIRST THROW) 'AND (SECOND THROW) '-- 'YOUR 'POINT 'IS (+ (FIRST THROW) 
																																											 (SECOND THROW))))
						 )        ;;; end COND

			 )           ;;; end LET


)


;;; ======================================== END OF PROGRAM CRAPS ======================================== ;;;
