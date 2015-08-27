#lang plai

(print-only-errors true)

(define-type WAE
  [num (n number?)]
  [add (lhs WAE?)
       (rhs WAE?)]
  [sub (lhs WAE?)
       (rhs WAE?)]
  [with (name symbol?)
        (named-expr WAE?)
        (body WAE?)]
  [id (name symbol?)])

;; parse : s-exp -> WAE
(define (parse sexp)
  (cond
    [(number? sexp) (num sexp)]
    [(symbol? sexp) (id sexp)]
    [(list? sexp)
     (case (first sexp)
       [(+) (add (parse (second sexp))
                 (parse (third sexp)))]
       [(-) (sub (parse (second sexp))
                 (parse (third sexp)))]
       [(with) (with (first (second sexp))
                     (parse (second (second sexp)))
                     (parse (third sexp)))])]))

;; subst-v0.1 : WAE symbol WAE
(define (subst-v0.1 expr sub-id val)
  (type-case WAE expr
    [num (n) expr]
    [add (l r) (add (subst-v0.1 l sub-id val)
                    (subst-v0.1 r sub-id val))]
    [sub (l r) (sub (subst-v0.1 l sub-id val)
                    (subst-v0.1 r sub-id val))]
    [with (bound-id named-expr bound-body)
          (if (symbol=? bound-id sub-id)
              expr
              (with bound-id
                    named-expr
                    (subst-v0.1 bound-body sub-id val)))]
    [id (v) (if (symbol=? v sub-id) val expr)]))

;; subst-v0.2 : WAE symbol WAE
(define (subst-v0.2 expr sub-id val)
  (type-case WAE expr
    [num (n) expr]
    [add (l r) (add (subst-v0.2 l sub-id val)
                    (subst-v0.2 r sub-id val))]
    [sub (l r) (sub (subst-v0.2 l sub-id val)
                    (subst-v0.2 r sub-id val))]
    [with (bound-id named-expr bound-body)
          (if (symbol=? bound-id sub-id)
              expr
              (with bound-id
                    (subst named-expr sub-id val)
                    (subst-v0.2 bound-body sub-id val)))]
    [id (v) (if (symbol=? v sub-id) val expr)]))



;; subst : WAE symbol WAE
(define (subst expr sub-id val)
  (type-case WAE expr
    [num (n) expr]
    [add (l r) (add (subst l sub-id val)
                    (subst r sub-id val))]
    [sub (l r) (sub (subst l sub-id val)
                    (subst r sub-id val))]
    [with (bound-id named-expr bound-body)
          (if (symbol=? bound-id sub-id)
              (with bound-id
                    (subst named-expr sub-id val)
                    bound-body)
              (with bound-id
                    (subst named-expr sub-id val)
                    (subst bound-body sub-id val)))]
    [id (v) (if (symbol=? v sub-id) val expr)]))


;; calc : WAE -> number
(define (calc expr)
  (type-case WAE expr
    [num (n) n]
    [add (l r) (+ (calc l) (calc r))]
    [sub (l r) (- (calc l) (calc r))]
    [with (bound-id named-expr bound-body)
          (calc (subst bound-body
                      bound-id
                      (num (calc named-expr))))]
    [id (v) (error 'calc "free identifier")]))

(test (calc (parse '3)) 3) ;; 1 
(test (calc (parse '{+ 3 4})) 7) ;; 2
(test (calc (parse '{+ {- 3 4} 7})) 6) ;; 3
(test (calc (parse '{with {x {+ 5 5}} {+ x x}})) 20) ;; 4
(test (calc (parse '{with {x 5} {+ x x}})) 10) ;; 5
(test (calc (parse '{with {x {+ 5 5}} {with {y {- x 3}} {+ y y}}})) 14) ;; 6 Fails in v0.1
(test (calc (parse '{with {x 5} {with {y {- x 3}} {+ y y}}})) 4) ;; 7 Fails in v0.1
(test (calc (parse '{with {x 5} {+ x {with {x 3} 10}}})) 15) ;; 8
(test (calc (parse '{with {x 5} {+ x {with {x 3} x}}})) 8) ;; 9
(test (calc (parse '{with {x 5} {+ x {with {y 3} x}}})) 10) ;; 10
(test (calc (parse '{with {x 5} {with {y x} y}})) 5) ;; 11 Fails in v0.1
(test (calc (parse '{with {x 5} {with {x x} x}})) 5) ;; 12 Fails in v0.1 and v0.2
