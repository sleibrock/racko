Racko, A Code Annotation Tool
=============================

Racko is a code annotation tool for generating easy-to-read source code documents. Racko is inspired by [Docco](https://github.com/jashkenas/docco). Racko is written in Racket and is distributed over Racket's main packaging tool `raco`.

## Setup

Racko can be installed from `raco` with the following command:

```bash
raco install racko
```

Racko can also be built locally and used that way.

```bash
git clone https://github.com/sleibrock/racko && cd racko
raco pkg install
```

That will install Racko locally and can be used during development as it will reference the local files once installed.

## Usage

Running Racko is very easy as it hooks right into `raco`'s command list. Racko requires a source code file to annotate and comes with a few options.

```bash
raco annotate path/to/sourcefile.cpp
```

Running that will place Racko's documents in a `docs/` folder in your current directory. The directoy path can be changed however.

A source file must be supported by Racko since the syntax highlighting is done by Racko and not a third party library. Languages supported are as follows:

* Racket
* C/C++
* Golang
* Python
* Ruby
* Haskell
* Rust

Adding a new language to the highlighter is trivial, simply add a few lists of keywords and set the comment leaders and Racko takes care of the rest.
