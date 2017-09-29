#lang racket/base

#|
Racko supported languages and other data in here

The lexer has to be improved upon because multiple groups will overlap
and cause coloring issues when smaller words are found in larger words.
Either keep it simple keywords, or come up with a new lexer idea that
works in most (if not all) cases and is easy to use to parse other
languages and color them accordingly.
|#

(provide all-languages
         print-supported-languages
         (struct-out highlighter))


(struct highlighter (slc mlcb mlce group))


; Define the Racket syntax keywords
; Defines and such things are different from logical blocks
; Things like car and #f/#t are considered data types
(define racket-syntax
  (highlighter
   ";"
   '(#rx"#\\|" "<span class=\"comment\">#|")
   '(#rx"\\|#" "|#</span>")
   '("define" "lambda" "λ" "struct" "require" "module" "module+" "provide" "submod"
              "when" "unless" "if" "cond" "begin" "begin0" "apply" "let")
   ))


; C++ syntax highlighter, works for both C/C++
; Macros/datatype expressions are different from logical keywords
; Things like return/break should be colored different from logical
(define cpp-syntax
  (highlighter
   "//"
   '(#rx"/\\*" "<span class=\"comment\">/*")
   '(#rx"\\*/" "*/</span>")
   '(
     "#define" "#ifdef" "#ifndef" "#endif" "#pragma" "#include" "#else"
     "typedef" "struct" "namespace" "typename" "public" "private" "protected"
     "return" "operator" "friend" "union" "auto" "delete" "unique_ptr" "shared_ptr")
   ))

; Python highlighter
; Python 2 and 3 have a few different differences in std namespace funcs
(define python-syntax
  (highlighter
   "#"
   "\"\"\""
   "\"\"\""
   '("from" "import" "this" "super" "return" "def")
   ))

; Ruby highlighter
; Add more syntax later
(define ruby-syntax
  (highlighter
   "#"
   "=begin"
   "=end"
   '("class")
   ))

; Haskell highlighter
; More to come
(define haskell-syntax
  (highlighter
   "--"
   "{-|"
   "|-}"
   '("import" "qualified" "Num")
   ))


; Go language highlighter
; More to come
(define go-syntax
  (highlighter
   "//"
   '(#rx"/\\*" "<span class='comment'>/*")
   '(#rx"\\*/" "*/</span>")
   '("package" "import" "var" "type" "struct" "func" "return" "defer"
               "switch" "case")
   ))

; Rust highlighter
; More to come
(define rust-syntax
  (highlighter
   "//"
   "/*"
   "*/"
   '("use" "crate" "pub" "mod" "type")
   ))

; Define the language list to use in the main program
; Use this as the lookup to determine if a given source file
; falls within any of these parser categories
(define all-languages
  (make-hash
   (list
    (list "rkt" (list "racket"    racket-syntax))
    (list "c"   (list "c"            cpp-syntax))
    (list "cpp" (list "c++"          cpp-syntax))
    (list "py"  (list "python"    python-syntax))
    (list "rb"  (list "ruby"        ruby-syntax))
    (list "hs"  (list "haskell"  haskell-syntax))
    (list "go"  (list "golang"        go-syntax))
    (list "rs"  (list "rust"        rust-syntax))
    )))


; print out all languages (useful when a file doesn't match too)
(define (print-supported-languages)
  (displayln "List of languages supported")
  (displayln "---------------------------")
  (for-each displayln (hash->list all-languages)))

