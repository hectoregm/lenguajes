#lang plai

(define (filter-pos l)
  (define filter-pos-tail
    (lambda (l accum)
      (cond
        [(empty? l) accum]
        [else (filter-pos-tail (cdr l) (append accum (if (> (car l) 0)
                                                         (list (car l))
                                                         empty)))])))
  (filter-pos-tail l empty))
(filter-pos '(1 0 2))

(define (filter-pos-bad l)
  (define filter-pos-tail
    (lambda (l accum)
      (cond
        [(empty? l) accum]
        [else (if (> (car l) 0)
                  (filter-pos-tail (cdr l) (cons (car l) accum))
                  (filter-pos-tail (cdr l) accum))])))
  (filter-pos-tail l empty))
(filter-pos-bad '(1 0 2))