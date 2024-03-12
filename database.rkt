#lang racket
(provide call/database/update read-database make-database-file
         database-set database-ref database-names database-xexprs database-pairs)

(define (read-database f)
  (call-with-file-lock/timeout
   f
   'shared
   (lambda () (file->value f))
   (lambda () (read-database f))))
(define (write-database d f)
  (call-with-file-lock/timeout
   f
   'exclusive
   (lambda () (write-to-file d f #:exists 'truncate/replace))
   (lambda () (write-database d f))))

(define (call/database/update f p)
  (write-database (p (read-database f)) f))
(define (make-database-file f)
  (write-database (make-empty-database) f))

(define (make-empty-database) (hash))
(define (database-set d name xexpr)
  (hash-set d name xexpr))
(define (database-ref d name)
  (hash-ref d name))
(define (database-names d)
  (hash-keys d))
(define (database-xexprs d)
  (hash-values d))
(define (database-pairs d)
  (hash->list d))
