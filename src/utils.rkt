#lang racket/base

#|
Racko utilities


|#

; Load required libs
(require racket/string)

; Load the rackunit lib into the test module
(module+ test
  (require rackunit))

; Provide certain functions and parameters
(provide file-reader
         get-extension
         write-lines-to-file
         trim-line
         sanitize-line
         remove-comment
         string-startswith?)


; Create a lazy file reader that returns a line each time it is called
; This is used to lazily read a file instead of reading all lines at once
(define (file-reader filename)
  (define p (open-input-file filename))
  (λ ()
    (read-line p)))


; Return a filename's extension without the period
; Assuming the filename even has a period
(define (get-extension filename)
  (car (reverse (string-split filename "."))))


; Return a function that will write lines to a given output port
(define (write-lines-to-file output-port lines)
  (for-each
   (λ (l)
     (displayln l output-port))
   lines))


; Trim a line so there's no whitespace at the left side
(define (trim-line line)
  (string-trim line " " #:repeat? #t #:right? #f))


; Sanitize a line of any HTML codes
(define (sanitize-line line)
  (regexp-replaces line '([#rx"<" "\\&lt;"] [#rx">" "\\&gt;"])))


; Remove a single-line comment pattern from the input string
; ie: "//Comment" becomes "Comment"
(define (remove-comment line slc)
  (string-trim (string-trim line slc #:right? #f) " " #:repeat? #t))


; See if String A starts with String B
; if String B is longer than String A, return false
(define (string-startswith? string-a string-b)
  (if (< (string-length string-a) (string-length string-b))
      #f
      (string=? string-b (substring string-a 0 (string-length string-b)))))

(module+ test
  (displayln "Tests go here"))
