#lang plai

(print-only-errors true)

;; mconcat : (listof a), (listof b) -> (listof c)
(define (mconcat lst1 lst2)
  (cond
    [(empty? lst2) lst1]
    [(empty? lst1) lst2]
    [else (mconcatAux (reversa lst1 '()) lst2)]))

(define (mconcatAux lst1 lst2)
  (cond
    [(empty? lst1) lst2]
    [else (mconcatAux (cdr lst1) (cons (car lst1) lst2))]))

(define (reversa lst1 lst2)
  (cond
    [(empty? lst1) lst2]
    [else(reversa (cdr lst1)(cons (car lst1) lst2))]))

(test (mconcat '(1 2) '(3 4)) '(1 2 3 4))
(test (mconcat '(1 2 3 4 5 6) '()) '(1 2 3 4 5 6))
(test (mconcat '() '(3 4 d s w)) '(3 4 d s w))
(test (mconcat '() '()) '())
(test (mconcat '(a b c d e) '(1 2 3 4 5)) '(a b c d e 1 2 3 4 5))

;; mmap : (a -> b), (listof a) -> (listof b)
(define (mmap f lst)
  (cond
    [(empty? lst) empty]
    [else (cons (f (first lst)) (mmap f (rest lst)))]))
(test (mmap (lambda (n) (add1 n)) '(1 2 3 4)) '(2 3 4 5))
(test (mmap cdr '((1 2 3) (4 5 6) (7 8 9))) '((2 3) (5 6) (8 9)))
(test (mmap car '((1 2 3) (2 3 4) (3 4 5))) '(1 2 3))

;; mpowerset : (listof a) -> (listof b)
(define (mpowerset lst)
  (define (p-aux elem lst)
    (cond
      [(empty? lst) (list empty (list elem))]
      [else (mconcat lst (mmap (lambda (alst) (mconcat (list elem) alst)) lst))]))
  (cond
    [(empty? lst) '(())]
    [else (p-aux (first lst) (mpowerset (rest lst)))]))
(test (mpowerset '()) '(()))
(test (mpowerset '(1)) '(() (1)))
(test (mpowerset '(1 2)) '(() (2) (1) (1 2)))