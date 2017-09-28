#lang racket/base

#|
Racko supported languages and other data in here

|#

(provide all-languages
         print-supported-languages
         (struct-out highlighter))


(struct highlighter (slc mlcb mlce group1 group2 group3))


; Define the Racket syntax keywords
; Defines and such things are different from logical blocks
; Things like car and #f/#t are considered data types
(define racket-syntax
  (highlighter
   ";"
   "#|"
   "|#"
   '("define" "lambda" "λ" "struct" "require" "module" "module+")
   '("let" "let*" "letrec" "if" "cond" "when" "unless" "for" "for-each" "map"
           "filter" "length" "null" "andmap" "ormap" "foldl" "foldr" "empty"
           "take" "drop" "split-at" "apply" "range")
   '("#f" "#t" "car" "cdr" "first" "second" "third" "fourth" "fifth" "sixth"
          "seventh" "eight" "ninth" "tenth" "cadr" "caddr" "cadddr" "caddddr")))


; C++ syntax highlighter, works for both C/C++
; Macros/datatype expressions are different from logical keywords
; Things like return/break should be colored different from logical
(define cpp-syntax
  (highlighter 
   "//"
   "/*"
   "*/"
   '("#define" "#ifdef" "#ifndef" "#endif" "#pragma" "typedef" "struct"
               "namespace" "typename" "class" "public" "private" "protected"
               "void" "short" "long" "unsigned" "int" "char" "bool" "double"
               "float" "new" "enum" "true" "false" "static" "extern" "const"
               "union" "this" "uint32_t" "uint16_t" "uint8_t" "char16_t"
               "char32_t" "register" "inline" "decltype" "constexpr" "friend"
               "auto" "delete" "unique_ptr" "shared_ptr")
   '("if" "switch" "case" "else" "do" "while" "for" "asm" "operator")
   '("return" "break" "continue" "goto" "NULL" "M_PI")))

; Python highlighter
; Python 2 and 3 have a few different differences in std namespace funcs
(define python-syntax
  (highlighter
   "#"
   "\"\"\""
   "\"\"\""
   '("from" "import" "this" "eval" "help" "dir" "exec" "super")
   '("int" "float" "bool" "set" "frozenset" "dict" "list" "tuple" "object"
           "bytes" "str" "globals" "locals" "memoryview" "iter" "complex"
           "Exception" "IOError" "KeyboardInterrupt" "BaseException"
           "EOFError" )
   '("if" "else" "elif" "while" "for" "map" "filter" "lambda" "return")))

; Ruby highlighter
; Add more syntax later
(define ruby-syntax
  (highlighter
   "#"
   "=begin"
   "=end"
   '("class")
   '("puts")
   '("if" "end" "def")))

; Haskell highlighter
; More to come
(define haskell-syntax
  (highlighter
   "--"
   "{-|"
   "|-}"
   '("import" "qualified")
   '("Int" "Bool" "Num" "Eq" "Ord")
   '()
   ))


; Go language highlighter
; More to come
(define go-syntax
  (highlighter
   "//"
   "/*"
   "*/"
   '("package" "import" "var" "type" "struct")
   '("bool" "int" "string" "uint" "uint64" "float64" "complex128")
   '("const" "func")
   ))

; Rust highlighter
; More to come
(define rust-syntax
  (highlighter
   "//"
   "/*"
   "*/"
   '("use" "crate" "pub" "mod" "type")
   '("i32" "i64" "u32" "u64" "bool" "f32" "f64")
   '("if" "else" "return" "loop" "match" "impl" "trait")))

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

