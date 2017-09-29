#lang racket/base

#|
Racko utilities

Contains:
  * string functions
  * regex functions
  * file reading utilities and file pathing
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
         string-startswith?
         regexp-contains?
         regexp-replace-pair
         get-file-from-path) 


; Create a file reader that returns a line each time it is called
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
  (for-each (λ (l) (displayln l output-port)) lines))

; Trim a line so there's no whitespace at the left side
(define (trim-line line)
  (string-trim line " " #:repeat? #t #:right? #f))


; Sanitize a line of any HTML codes
; Should also replace any tab lines with spaces fully
(define (sanitize-line line)
  (regexp-replaces line '([#rx"\t"  "    "]
                          [#rx"<" "\\&lt;"]
                          [#rx">" "\\&gt;"])))


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


; Determine if string A exists in B (using regexp-match)
(define (regexp-contains? ra b)
  (not (eq? #f (regexp-match ra b))))


; Regexp replace with a pair on a string
; The pair should be '(#rx str)
(define (regexp-replace-pair str pair)
  (regexp-replace (car pair) str (car (cdr pair))))


; Retrieve the file from a given path
(define (get-file-from-path p)
  (define-values (fullpath filename isdir?) (split-path p))
  (values filename))


(module+ test
  (displayln "Tests go here"))
