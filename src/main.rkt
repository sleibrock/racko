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

(require "parser.rkt")

(module+ main
  (main))
