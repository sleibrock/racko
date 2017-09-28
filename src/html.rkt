#lang racket/base

(require "utils.rkt")

(provide generate-html-header
         generate-html-footer
         base-css
         css-dark-theme)

(define (generate-html-header filename style theme js)
  (list "<!doctype html>"
        "<html>"
        "<head>"
        "<title>"
        filename
        "</title>"
        "<style>"
        style
        theme
        "</style>"
        "<script>"
        js
        "</script>"
        "</head>"
        "<body>"
        "<div id=\"container\">"
        "<div id=\"background\"></div>"
        "<li>"
        "<div class=\"annotation\">"
        "<h1>"
        filename
        "</h1>"
        "</div>"
        "</li>"))


(define (generate-html-footer)
  (list
   "</ul>"
   "</div>"
   "<footer><a href=\"https://github.com/sleibrock/racko\">Created by Racko</a></footer>"
   "</body>"
   "</html>"))

; CSS styling should be broken up into two different aspects
; 1) the size and grid information that creates the size rules
; 2) the section color information
; This way we can color the docs with various colors without having to
; alter the (considerably long) sizing CSS ruleset

(define base-css "
html {
  height: 100%;
}

body {
  font-size: 14px;
  line-height: 18px;
  height: 100%;
  margin: 0;
  padding: 0;
}

#container {
  min-height: 100%;
  position: relative;
}

#background {
  background: #fff;
  position: absolute;
  top: 0;
  bottom: 0;
  width: 350px;
  border-right: 1px solid #e5e5ee;
  z-index: -1;
}

ul {
  list-style: outside none none;
  padding: 0 0 5px 0;
  margin: 0;
}

li {
  white-space: nowrap;
}

div {
  display: inline-block;
box-sizing: border-box;
}

pre {
  font-size: 12px;
  line-height: 16px;
  font-family: Menlo, Monaco, Consolas, \"Lucida Console\", monospace;
  margin: 0;
  padding: 0;
}

.annotation {
  max-width: 350px;
  min-width: 350px;
  min-height: 5px;
  padding: 13px;
  overflow-x: hidden;
  white-space: normal;
  text-align: left;
  vertical-align: top;
}

.content {
  padding: 13px;
  vertical-align: top;
  border: none;
}

")

(define css-dark-theme "

body {
background-color: black;
color: #ccc;
}

#background {
background-color: #222;
}

.annotation {
color: #eee;
}

.content {

}
")
