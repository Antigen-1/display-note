#lang info
(define collection "display-note")
(define racket-launcher-names (list "display-note" "update-note"))
(define racket-launcher-libraries (list "main.rkt" "update.rkt"))
(define install-collection "installer.rkt")
(define deps (list "base"
                   "web-server-lib"
                   "pollen"
                   "sugar"
                   "txexpr"
                   "git://github.com/Antigen-1/hasket.git"))
