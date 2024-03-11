#lang racket
(require "installer.rkt" racket/runtime-path)

(define-runtime-path build "build")

(define/contract transport
  (or/c 'https #;'http 'git)
  (cond ((getenv "NOTE_TRANSPORT") => string->symbol) (else 'https)))

(define temp (make-temporary-directory "temp~a"))
(define sub-build (build-path temp "build"))

(delete-directory/files build #:must-exist? #f)
(installer #f temp #:dest-dir (make-temporary-directory "note~a" #:base-dir temp) #:transport transport)
(copy-directory/files sub-build build)
(delete-directory/files temp)
