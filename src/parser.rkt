#lang racket/base

#|
The main parsing logic program

Contains all logic and functions related to HTML
annotation file creation.

The program relies heavily on parameters for the
time being. Threading this program safely is
not quite there yet.
|#

(require racket/string
         racket/cmdline
         "utils.rkt"
         "languages.rkt"
         "html.rkt")

(provide main)


; Program constants
(define PROGRAM-NAME     "raco annotate")
(define JS-FILENAME          "script.js")
(define CSS-FILENAME         "style.css")

; Program command line options
(define inline-cssjs         (make-parameter           #f))
(define verbosity-mode       (make-parameter           #f))
(define output-base-folder   (make-parameter       "docs"))

; parser parameters for rendering html and other things
(define section-number       (make-parameter            0))
(define code-accum           (make-parameter           ""))
(define inside-section?      (make-parameter           #f))
(define inside-annotation?   (make-parameter           #f))
(define multi-comment?       (make-parameter           #f))
(define file-title-name      (make-parameter  "file.html"))

(define line-num             (make-parameter            1))
(define current-line         (make-parameter           ""))


; return a path based on the target folder and filename
(define (build-file-path output filename)
  (define-values (dir fname d?) (split-path filename))
  (build-path (current-directory)
              output
              (string-append (path->string fname) ".html")))


; Replace all keywords in a line with a keyword list
; The group-func is the syntax group the keylist belongs to
(define (replace-keyword keylist group-func)
  (for-each
   (λ (keyword)
     (current-line
      (regexp-replace keyword (current-line) (group-func keyword))))
   keylist))


; add code to the code accumulator
(define (add-code line hl output)
  (current-line line)
  
  (unless (inside-section?)
    (inside-section? #t)
    (displayln "<li><div class='annotation'></div><div class='content'><pre>" output))

  (when (inside-annotation?)
    (displayln "</div><div class='content'><pre>" output)
    (inside-annotation? #f))

  (unless (multi-comment?)
    (when (regexp-contains? (car (highlighter-mlcb hl)) (current-line))
      (multi-comment? #t)
      (displayln (format "Found a multi line comment begin on ~a" (line-num)))
      (current-line (regexp-replace-pair (current-line) (highlighter-mlcb hl)))))

  (when (multi-comment?)
    (when (regexp-contains? (car (highlighter-mlce hl)) (current-line))
      (multi-comment? #f)
      (displayln "Found the end of multi comment")
      (current-line (regexp-replace-pair (current-line) (highlighter-mlce hl)))))

  (unless (multi-comment?)
    (replace-keyword (highlighter-group hl) phrase1))

  (line-num (add1 (line-num)))
  (code-accum (string-append (code-accum) (current-line) "\n")))


; write code to the file from the accumulator
(define (write-code output)
  (unless (string=? "" (code-accum))
    (displayln (code-accum) output)
    (code-accum "")
    (displayln "</pre></div></li>" output)
    (inside-section? #f)))


; writing code lines goes here
(define (write-comment-line line output)

  (write-code output) ; flush any code and close a section

  (unless (inside-section?)
    (inside-section? #t)
    (inside-annotation? #t)
    (displayln "<li><div class='annotation'>" output))

  (displayln "<p>"  output)
  (displayln line   output)
  (displayln "</p>" output))


; Line read logic goes here
; Insert the line if it's a single-line-comment leaded string
; If it's a line of code, add it to the code accumulator
(define (parse-line line hl output-port)
  (define sanitized-line (sanitize-line line))
  (define trimmed-line (trim-line sanitized-line))
  (if (string-startswith? trimmed-line (highlighter-slc hl))
      (write-comment-line (remove-comment trimmed-line (highlighter-slc hl)) output-port)
      (add-code sanitized-line hl output-port)))


; build a parser using a syntax rules struct
(define (parse-file filename syntaxer)
  
  (define fr (file-reader (string->path filename)))
  (define op (open-output-file
              (build-file-path (output-base-folder) filename) #:exists 'replace))
  
  (write-lines-to-file
   op
   (generate-html-header
    (get-file-from-path filename) base-css css-dark-theme ""))

  (define (parse-all-lines generator)
    (define line (generator))
    (unless (eof-object? line)
      (parse-line line syntaxer op)
      (parse-all-lines generator)))
  
  (parse-all-lines fr)
  
  (write-code op)

  (write-lines-to-file op (generate-html-footer))
  
  (displayln "File successfully parsed"))


; Create a new file and find it's highlighter
; If no highlighter exists, quit the program
(define (create-docs filename)
  (define extension (get-extension filename))
  
  (unless (hash-has-key? all-languages (get-extension filename))
    (displayln "Not supported!")
    (exit 0))

  (define selected (car (hash-ref all-languages extension)))
  (define lang     (car selected))
  (define syntaxer (car (cdr selected)))

  (when (verbosity-mode)
    (displayln (format "File given: ~a"    filename))
    (displayln (format "Extension: ~a"     extension))
    (displayln (format "Output folder: ~a" (output-base-folder)))
    (displayln (format "Language: ~a"      lang)))

  (parse-file filename syntaxer)
  (displayln "Done"))


(define (main)
  (command-line
   #:program PROGRAM-NAME
   #:once-each
   [("-v" "--verbose") "Enable more text at runtime" (verbosity-mode #t)]
   [("-o" "--output")
    output-dir
    "Destination folder to save docs to" (output-base-folder output-dir)]

   [("--print-languages") "Print supported languages" (print-supported-languages) (exit 0)]

   #:args (filename)
   (create-docs filename)
   ))
