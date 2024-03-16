#lang racket
(require "installer.rkt" "build_lock.rkt")

(module* function #f
  (provide (contract-out (update (->* () ((or/c 'https #;'http 'git)) any))))
  (define (update (transport 'https))
    (define temp (make-temporary-directory "temp~a"))
    (define sub-build (build-path temp "build"))

    (installer #f temp #:dest-dir (make-temporary-directory "note~a" #:base-dir temp) #:transport transport)

    (call-with-build-lock
     #:mode 'exclusive
     (lambda ()
       (delete-directory/files build #:must-exist? #f)
       (copy-directory/files sub-build build)))

    (delete-directory/files temp)))

(module* main racket
  (require (submod ".." function))

  (define/contract transport
    (or/c 'https #;'http 'git)
    (cond ((getenv "NOTE_TRANSPORT") => string->symbol) (else 'https)))
  (update transport))
