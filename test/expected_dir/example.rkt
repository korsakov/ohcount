racket	comment	;; language declaration commented out until someone extends the
racket	comment	;; parser to support it:
racket	blank	
racket	comment	;; #lang racket
racket	blank	
racket	comment	;; Report each unique line from stdin
racket	code	(let ([saw (make-hash)])
racket	code	  (for ([line (in-lines)])
racket	code	    (unless (hash-ref saw line #f)
racket	code	      (displayln line))
racket	code	    (hash-set! saw line #t)))
racket	blank	
