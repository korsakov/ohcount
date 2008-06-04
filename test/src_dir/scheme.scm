(+ 1 (/ 1 0) 3)
; => A divide by zero error is raised

(with-failure-continuation
    (lambda (error-record error-k)
      'error)
  (lambda () (+ 1 (/ 1 0) 3)))
; => The symbol 'error

(with-failure-continuation
    (lambda (error-record error-k)
      (error-k 2))
  (lambda () (+ 1 (/ 1 0) 3)))
; => 6

(with-failure-continuation
    (lambda (error-record error-k)
      (throw error-record error-k))
  (lambda () (+ 1 (/ 1 0) 3)))
; => A divide by zero error is raised

(with-failure-continuation
    (lambda (error-record error-k)
      (throw (make-error '/ "could not perform the division.") error-k))
  (lambda () (+ 1 (/ 1 0) 3)))
; => An error is raised: Error in /: could not perform the division.

(with-failure-continuation
    (lambda (error-record error-k)
      (error 'example-function "could not evaluate the expression."))
  (lambda () (+ 1 (/ 1 0) 3)))
; => An error is raised: Error in example-function: could not evaluate the expression.
