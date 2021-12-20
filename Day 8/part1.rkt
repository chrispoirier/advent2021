#lang racket

(define lenMap '(2 4 3 7))

(define input (call-with-input-file "input"
                (lambda(inputFile)
                  (map (lambda (line)
                         (map (lambda (part)
                                (string-split part " "))
                          (string-split line " | ")))
                   (port->lines inputFile))
                  )))

(define (decode-line toCheck count)
  (cond [(null? toCheck) count]
        [#t (letrec ([newCount (+ count
                                  (if (not (member (string-length (car toCheck)) lenMap))
                                      0
                                      1))])
              (decode-line (cdr toCheck) newCount))]))

(define (decode lines count)
  (cond [(null? lines) count]
        [#t (decode (cdr lines)  (+ count (decode-line (cadar lines) 0)))]))
  

(println (string-append "Count of 1,4,7,8: " (number->string (decode input 0))))