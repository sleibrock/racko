; Racko, a code documenting tool
#lang racket/base

#|
Source files are made up of different syntaxes and keywords
Different words and segments should be colored different

Colors will be broken down into the following groups:
keyword, type, comment

Each group can have multiple coloring tags to customize
syntax and make certain syntax stand out better
ie; 'for' in C++ can have a different coloring than 'return'


|#

(require racket/cmdline)
(require racket/string)

(define PROGRAM-NAME    "racko")
(define PROGRAM-VERSION   "0.1")

(define inline-cssjs       (make-parameter #f))
(define verbosity-mode     (make-parameter #f))
(define output-base-folder (make-parameter "docs"))

(struct psettings (sl-comment-begin ml-comment-begin ml-comment-end))

(define (print-help)
  (displayln "HELP SCREEN")
  (print-supported-extensions))

(define (build-file-path filename)
  (build-path (current-directory)
              (output-base-folder)
              (string-append filename ".html")))

; build a parser using a settings struct(?)
(define (parser parse-settings)
  (λ (filename)
    (define fr (file-reader filename))
    (define op (open-output-file (build-file-path filename)))
    (displayln "I'm parsing a file!")))

; all languages supported (start with racket and c++)
(define languages
  (make-hash
   (list
    (list "rkt" (list "racket" (parser (psettings ";" #rx"#|" #rx"|#")))))))

(define (print-supported-extensions)
  (displayln "List of Languages supported")
  (displayln "---------------------------")
  (for-each displayln (hash->list languages)))

(define (get-extension filename)
  (car (reverse (string-split filename "."))))

(define (create-docs filename)
  (when (verbosity-mode)
    (displayln (format "File given: ~a" filename))
    (displayln (format "Extension: ~a" (get-extension filename)))
    (displayln (format "Output folder: ~a" (output-base-folder)))
    (displayln (format "Target file: ~a" (path->string (build-file-path filename))))
    )
  (displayln "Done"))


; A file reading generator that reads a file line-by-line
; Returns the next line in the file each time it is called
(define (file-reader filename)
  (define p (open-input-file filename))
  (λ ()
    (read-line p)))

(command-line
 #:program PROGRAM-NAME
 #:once-each
 [("-v" "--verbose") "Enable more text at runtime" (verbosity-mode #t)]
 [("-o" "--output")
  output-dir
  "Destination folder to save docs to" (output-base-folder output-dir)]

 [("--print-languages") "Print supported languages" (print-supported-extensions) (exit 0)]

 #:args (filename)
 (create-docs filename)
 )
