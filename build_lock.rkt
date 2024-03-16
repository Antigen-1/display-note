#lang racket
(require racket/runtime-path)
(provide call-with-build-lock build)

(define-runtime-path build "build")
(define (call-with-build-lock p #:mode m)
  (call-with-file-lock/timeout
   build
   m
   p
   (lambda () (call-with-build-lock p #:mode m))))
