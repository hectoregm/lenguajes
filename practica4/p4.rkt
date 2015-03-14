#lang plai

(require "p4-base.rkt")

(define (get-symbols lst)
  (cond
    [(empty? lst) empty]
    [else (cons (bind-name (car lst)) (get-symbols (cdr lst)))]))

(define (get-faes lst)
  (cond
    [(empty? lst) empty]
    [else (cons (desugar (bind-val (car lst))) (get-faes (cdr lst)))]))

(define (desugar expr)
  (type-case FAES expr
    [numS (n) (num n)]
    [idS (s) (id s)]
    [binopS (f l r) (binop f (desugar l) (desugar r))]
    [withS (bindings body) (app (fun (get-symbols bindings) (desugar body)) (get-faes bindings))]
    [else empty]))

(test (desugar (parse '{+ 3 4})) (binop + (num 3) (num 4)))
(test (desugar (parse '{+ {- 3 4} 7})) (binop + (binop - (num 3) (num 4)) (num 7)))
(test (desugar (parse '{with {{x {+ 5 5}}} x})) (app (fun '(x) (id 'x)) (list (binop + (num 5) (num 5))) ))