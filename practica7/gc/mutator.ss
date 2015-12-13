#lang plai/mutator

(allocator-setup "collector.ss" 84)

(define (fact x)
  (if (zero? x)
      1
      (* x (fact (sub1 x)))))

(define (fact-help x a)
  (if (zero? x)
      a
      (fact-help (sub1 x) (* x a))))

(define lst (cons 1 (cons 2 (cons 3 empty))))

(define (map-add n lst)
  (map (lambda (x) (+ n x)) lst))

(define (map f lst)
  (if (cons? lst)
      (cons (f (first lst)) (map f (rest lst)))
      empty))

(define (filter p lst)
  (if (cons? lst)
      (if (p (first lst))
          (cons (first lst) (filter p (rest lst)))
          (filter p (rest lst)))
      lst))

(define (append l1 l2)
  (if (cons? l1)
      (cons (first l1) (append (rest l1) l2))
      l2))

(define (length lst)
  (if (empty? lst)
      0
      (add1 (length (rest lst)))))

(define tail (cons 1 empty))
(define head (cons 4 (cons 3 (cons 2 tail))))
(set-rest! tail head)

(test/value=? lst '(1 2 3)) ; Why down here? Maybe stuff got GC'd

(test/location=? head (rest tail)) ; circular list

(set! head empty)
(set! tail head)

; We've lost pointers to that circular data structure

; Note that the literal 2 and '(0 1 2) on the right hand side are _not_
; allocated on the mutator's heap.  The are allocated in Scheme's heap
; and test/value=? checks for structural equality.
(test/value=? (length '(hello goodbye)) 2)
(test/value=? (map sub1 lst) '(0 1 2))

(test/value=? (fact-help 15 1) 130767436800)
(test/value=? (fact 9) 362880)

(test/value=? (append lst lst) '(1 2 3 1 2 3))

(test/value=? (map-add 5 lst) '(6 7 8))
(test/value=? (filter even? (map sub1 lst)) '(0 2))
(test/value=? (length lst) 3)
