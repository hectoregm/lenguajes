#lang plai

;; fac: number -> number
;; Calcula el factorial de un numero positivo.
(define (fac n)
  (cond
    [(zero? n) 1]
    [(= n 1) 1]
    [else (* n (fac (sub1 n)))]))
(test (fac 0) 1)
(test (fac 1) 1)
(test (fac 6) 720)

;; butlast: list of values -> list of values
;; Toma una lista y regresa una lista con los elementos de la lista
;; original pero sin el ultimo elemento
(define (butlast lst)
  (cond
    [(empty? lst) empty]
    [(empty? (rest lst)) empty]
    [else (cons (first lst) (butlast (rest lst)))]))
(test (butlast '()) '())
(test (butlast (list 1 2 3 4)) '(1 2 3))
(test (butlast (list "hola " "como " "estas?")) '("hola " "como "))

;; mflatten : listof values -> listof values
;; Toma una lista con posibles listas anidadas y regresa una
;; lista con todos los elementos de estas listas.
(define (mflatten lst)
  (cond
    [(empty? lst) empty]
    [else (if (list? (first lst))
              (append (flatten (first lst)) (mflatten (rest lst)))
              (append (list (first lst)) (mflatten (rest lst))))]))
(test (mflatten '()) '())
(test (mflatten '(1 2 3)) '(1 2 3))
(test (mflatten '((1 4) 2 3)) '(1 4 2 3))
(test (mflatten '((1 (4 5 6)) 2 3)) '(1 4 5 6 2 3))
