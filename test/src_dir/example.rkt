;; language declaration commented out until someone extends the
;; parser to support it:

;; #lang racket

;; Report each unique line from stdin
(let ([saw (make-hash)])
  (for ([line (in-lines)])
    (unless (hash-ref saw line #f)
      (displayln line))
    (hash-set! saw line #t)))

