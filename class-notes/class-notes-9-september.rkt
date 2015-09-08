#lang plai

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