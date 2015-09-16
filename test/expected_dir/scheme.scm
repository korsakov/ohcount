scheme	code	(+ 1 (/ 1 0) 3)
scheme	comment	; => A divide by zero error is raised
scheme	blank	
scheme	code	(with-failure-continuation
scheme	code	    (lambda (error-record error-k)
scheme	code	      'error)
scheme	code	  (lambda () (+ 1 (/ 1 0) 3)))
scheme	comment	; => The symbol 'error
scheme	blank	
scheme	code	(with-failure-continuation
scheme	code	    (lambda (error-record error-k)
scheme	code	      (error-k 2))
scheme	code	  (lambda () (+ 1 (/ 1 0) 3)))
scheme	comment	; => 6
scheme	blank	
scheme	code	(with-failure-continuation
scheme	code	    (lambda (error-record error-k)
scheme	code	      (throw error-record error-k))
scheme	code	  (lambda () (+ 1 (/ 1 0) 3)))
scheme	comment	; => A divide by zero error is raised
scheme	blank	
scheme	code	(with-failure-continuation
scheme	code	    (lambda (error-record error-k)
scheme	code	      (throw (make-error '/ "could not perform the division.") error-k))
scheme	code	  (lambda () (+ 1 (/ 1 0) 3)))
scheme	comment	; => An error is raised: Error in /: could not perform the division.
scheme	blank	
scheme	code	(with-failure-continuation
scheme	code	    (lambda (error-record error-k)
scheme	code	      (error 'example-function "could not evaluate the expression."))
scheme	code	  (lambda () (+ 1 (/ 1 0) 3)))
scheme	comment	; => An error is raised: Error in example-function: could not evaluate the expression.
