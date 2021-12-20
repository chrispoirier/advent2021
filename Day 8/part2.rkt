#lang racket

(define lengths (list 2 3 4 5 6 7))

(define positions (list "a" "b" "c" "d" "e" "f" "g"))

(define number-displays (list
                         (list 0 "a" "b" "c" "e" "f" "g")
                         (list 1 "c" "f")
                         (list 2 "a" "c" "d" "e" "g")
                         (list 3 "a" "c" "d" "f" "g")
                         (list 4 "b" "c" "d" "f")
                         (list 5 "a" "b" "d" "f" "g")
                         (list 6 "a" "b" "d" "e" "f" "g")
                         (list 7 "a" "c" "f")
                         (list 8 "a" "b" "c" "d" "e" "f" "g")
                         (list 9 "a" "b" "c" "d" "f" "g")
                         ))

(define input (call-with-input-file "input"
                (lambda(inputFile)
                  (map (lambda (line)
                         (map (lambda (part)
                                (map (lambda (key) (sort (string->list key) char<?))
                                (string-split part " ")))
                          (string-split line " | "))) 
                   (port->lines inputFile))
                  )))

(define (sort-by-length a b)
  (letrec ([len-a (length a)]
           [len-b (length b)])
    (< len-a len-b)))

(define (get-keys-by-length keys len)
  (letrec ([helper (lambda (keys acc)
                    (cond [(empty? keys) acc]
                          [(= len (length (car keys))) (helper (cdr keys) (append (list (car keys)) acc))]
                          [#t (helper (cdr keys) acc)]))])
    (helper keys '())
  ))

(define (get-keys-by-lengths keys)
  (letrec ([helper (lambda (iLengths acc)
                    (cond [(empty? iLengths) acc]
                          [#t (helper (cdr iLengths) (cons (list (car iLengths) (get-keys-by-length keys (car iLengths))) acc))]))])
    (helper lengths '())
  ))

; Return the elements of list-a that are not in list-b
(define (list-subtract list-a list-b)
  (letrec ([helper (lambda (list-src acc)
                     (cond [(empty? list-src) acc]
                           [(not (member (car list-src) list-b)) (helper (cdr list-src) (cons (car list-src) acc))]
                           [#t (helper (cdr list-src) acc)]))])
    (helper list-a '())
    ))

; Return true if list-a contains all elements of list-b
(define (all-members list-a list-b)
  (letrec ([helper (lambda (list-src)
                     (cond [(empty? list-src) #t]
                           [(member (car list-src) list-a) (helper (cdr list-src))]
                           [#t #f]))])
    (helper list-b)
    ))

(define (hash-find hash value)
  (letrec ([value-char (if (char? value) value (car (string->list value)))]
           [helper (lambda(keys)
                     (cond
                       [(empty? keys) #f]
                       [(equal? (hash-ref hash (car keys)) value-char) (car (string->list (car keys)))]
                       [#t (helper (cdr keys))])
                     )])
    (helper (hash-keys hash))
    ))

(define (hash-find-list hash list-vals)
  (letrec ([helper (lambda(vals acc)
                     (cond
                       [(empty? vals) acc]
                       [#t (helper (cdr vals) (cons (hash-find hash (car vals)) acc))])
                     )])
    (helper list-vals '())
    ))

(define (hash-ref-list hash list-vals)
  (letrec ([helper (lambda(vals acc)
                     (cond
                       [(empty? vals) acc]
                       [#t (helper (cdr vals) (cons (hash-ref hash (string (car vals))) acc))])
                     )])
    (helper list-vals '())
    ))

(define (digits-to-number list)
  (+
   (car list)
   (* (cadr list) 10)
   (* (caddr list) 100)
   (* (cadddr list) 1000)
  ))

(define (create-number-letter-map keys)
  (letrec ([number-map (make-hash (list
                               (cons 0 #f)
                               (cons 1 #f)
                               (cons 2 #f)
                               (cons 3 #f)
                               (cons 4 #f)
                               (cons 5 #f)
                               (cons 6 #f)
                               (cons 7 #f)
                               (cons 8 #f)
                               (cons 9 #f)
                                ))]
           [letter-map (make-hash (list
                               (cons "a" #f)
                               (cons "b" #f)
                               (cons "c" #f)
                               (cons "d" #f)
                               (cons "e" #f)
                               (cons "f" #f)
                               (cons "g" #f)
                                ))]
           [keys-assoc (get-keys-by-lengths keys)]
           [determine-number-map-1 (lambda()
                                     (letrec ([fives (cadr (assoc 5 keys-assoc))])
                                       (hash-set! number-map 1 (caadr (assoc 2 keys-assoc))) +
                                       (hash-set! number-map 4 (caadr (assoc 4 keys-assoc))) +
                                       (hash-set! number-map 7 (caadr (assoc 3 keys-assoc))) +
                                       (hash-set! number-map 8 (caadr (assoc 7 keys-assoc))) +
                                       (hash-set! number-map 3 (findf (lambda(key) (all-members key (caadr (assoc 2 keys-assoc)))) fives))
                                       )
                                     )]
           [determine-letter-map-1 (lambda()
                                     (letrec ([map-1 (hash-ref number-map 1)]
                                              [map-4 (list-subtract (hash-ref number-map 4) map-1)]
                                              [map-7 (list-subtract (hash-ref number-map 7) map-1)]
                                              [map-3 (list-subtract (list-subtract (hash-ref number-map 3) (hash-ref number-map 7)) map-4)])
                                       (hash-set! letter-map "c" map-1) +
                                       (hash-set! letter-map "f" map-1) +
                                       (hash-set! letter-map "b" map-4) +
                                       (hash-set! letter-map "d" map-4) +
                                       (hash-set! letter-map "a" (car map-7)) +
                                       (hash-set! letter-map "g" (car map-3))
                                       )
                                     )]
           [determine-number-map-2 (lambda()
                                     (letrec ([fives (cadr (assoc 5 keys-assoc))]
                                              [map-3 (hash-ref number-map 3)]
                                              [map-5 (findf (lambda(key) (all-members key (hash-ref letter-map "b"))) (list-subtract fives (list map-3)))])
                                       (hash-set! number-map 5 map-5) +
                                       (hash-set! number-map 2 (car (list-subtract (list-subtract fives (list map-3)) (list map-5))))
                                     )
                                     )]
           [determine-letter-map-2 (lambda()
                                     (letrec ([map-1 (hash-ref number-map 1)]
                                              [map-2 (hash-ref number-map 2)]
                                              [map-3 (hash-ref number-map 3)]
                                              [map-4 (hash-ref number-map 4)]
                                              [map-5 (hash-ref number-map 5)]
                                              [map-bd (list-subtract map-4 map-1)]
                                              )
                                       (hash-set! letter-map "e" (car (list-subtract map-2 map-3))) +
                                       (hash-set! letter-map "c" (car (list-subtract map-1 map-5))) +
                                       (hash-set! letter-map "f" (car (list-subtract map-1 map-2))) +
                                       (hash-set! letter-map "b" (car (list-subtract map-bd map-2))) +
                                       (hash-set! letter-map "d" (car (list-subtract map-bd (list (hash-ref letter-map "b")))))
                                       )
                                     )]
           [determine-number-map-3 (lambda()
                                     (letrec ([sixes (cadr (assoc 6 keys-assoc))]
                                              ;[map-cfe (list (hash-ref letter-map "c") (hash-ref letter-map "f") (hash-ref letter-map "e"))]
                                              ;[map-bfe (list (hash-ref letter-map "b") (hash-ref letter-map "f") (hash-ref letter-map "e"))]
                                              ;[map-cfb (list (hash-ref letter-map "c") (hash-ref letter-map "f") (hash-ref letter-map "b"))]
                                              ;[map-cfe (list (hash-find letter-map "c") (hash-find letter-map "f") (hash-find letter-map "e"))]
                                              ;[map-bfe (list (hash-find letter-map "b") (hash-find letter-map "f") (hash-find letter-map "e"))]
                                              ;[map-cfb (list (hash-find letter-map "c") (hash-find letter-map "f") (hash-find letter-map "b"))]
                                              [map-0 (hash-ref-list letter-map (list #\a #\b #\c #\e #\f #\g))]
                                              [map-6 (hash-ref-list letter-map (list #\a #\b #\d #\e #\f #\g))]
                                              [map-9 (hash-ref-list letter-map (list #\a #\b #\c #\d #\f #\g))]
                                              ;[map-0 (hash-find-list letter-map (list #\a #\b #\c #\e #\f #\g))]
                                              ;[map-6 (hash-find-list letter-map (list #\a #\b #\d #\e #\f #\g))]
                                              ;[map-9 (hash-find-list letter-map (list #\a #\b #\c #\d #\f #\g))]
                                              )
                                       ;(println (list "MAPS" map-cfe map-bfe map-cfb)) +
                                       ;(println (list "MAPS" map-0 map-6 map-9)) +
                                       ;(hash-set! number-map 0 (findf (lambda(key) (all-members key map-cfe)) sixes)) +
                                       ;(hash-set! number-map 6 (findf (lambda(key) (all-members key map-bfe)) sixes)) +
                                       ;(hash-set! number-map 9 (findf (lambda(key) (all-members key map-cfb)) sixes))
                                       (hash-set! number-map 0 (findf (lambda(key) (equal? (sort key char<?) (sort map-0 char<?))) sixes)) +
                                       (hash-set! number-map 6 (findf (lambda(key) (equal? (sort key char<?) (sort map-6 char<?))) sixes)) +
                                       (hash-set! number-map 9 (findf (lambda(key) (equal? (sort key char<?) (sort map-9 char<?))) sixes))
                                     )
                                     )]
           )
    ;(println keys-assoc) +
    (determine-number-map-1) +
    ;(println number-map) +
    (determine-letter-map-1) +
    ;(println letter-map) +
    (determine-number-map-2) +
    ;(println number-map) +
    (determine-letter-map-2) +
    ;(println letter-map) +
    (determine-number-map-3) +
    ;(println number-map)
    number-map
  ))

(define (decode-unit map value)
  (letrec ([helper (lambda(map-keys)
                     (cond [(empty? map-keys) #f]
                           [(equal? (sort (hash-ref map (car map-keys)) char<?) (sort value char<?)) (car map-keys)]
                           [#t (helper (cdr map-keys))])
                     )]
           [unit (helper (hash-keys map))])
    ;(println unit) +
    unit
  ))

(define (decode-line map value)
  ;(println map) +
  ;(println "") +
  (letrec ([helper (lambda(vals acc)
                     (cond [(empty? vals) acc]
                           [#t (helper (cdr vals) (cons (decode-unit map (car vals)) acc))])
                     )])
    (helper value '())
    ))

(define (decode lines sum)
  (cond [(null? lines) sum]
        [#t (letrec ([line-value (digits-to-number (decode-line
                            (create-number-letter-map (sort (caar lines) sort-by-length))
                            (cadar lines)))])
              ;(println line-value) +
              (decode (cdr lines) (+ sum line-value))
              )]
        ))
  
(println (string-append "Sum of all: " (number->string (decode input 0))))