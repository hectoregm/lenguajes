#lang plai

(require "practica3-base.rkt")

(define-type HRZ
  [resting (low number?)
           (high number?)]
  [warm-up (low number?)
           (high number?)]
  [fat-burning (low number?)
               (high number?)]
  [aerobic (low number?)
           (high number?)]
  [anaerobic (low number?)
             (high number?)]
  [maximum (low number?)
           (high number?)])

(define-type Time
  [delta (distance number?)
         (lhr number?)
         (hhr number?)
         (zone HRZ?)
         (time number?)])