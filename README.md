Markdown template for ebooks
=============================

- A template for creating epub and pdf books. Mostly aimed at fiction.

Usage
-----
Put your chapters in the `chapters` directory as `.md` files. The chapters will show up in the
book sorted by the filename. The samples are numbered, so `010_chapter.md`, ect. But you are
free to name your chapters however you want, as long as the names sort in the right order.

Along with the usual markdown features, `!!Chapter!!` will get translated into an English word
version of the current chapter number, starting with `One`. The chapter number gets incremented
each time you use `!!Chapter!!`. There is also `!!BREAK!!` which gets translated into a stylistic
break, those `* * *` that you sometimes see to signal a transition.

By default `make` will build the epub version of the book.
- `make pdf` will, well, make a pdf.
- `make docx` will, well, make a Word file.
- `make plain` will make a rough plain text version of the book.
- `make wrapped` will make a rough plain text version of the book with each paragraph wrapped onto a single line.
- `make x` will produce an exploded version of your epub file, for debugging purposes.

All of the output files end up in the `target` directory.

Configuring
-----
Doing the initial setup for a new book is a bit messy, but simple.
- Make a copy of this template.
- Change the title, author and copyright information in the following files: 
  - Makefile
  - header.adoc
  - metadata.yml
  - book-theme.yml

Note that in the Makefile you need to set both the `TITLE`, which is the full title of the book and
may include spaces, as well as `NAME`, which is the filename that your epub and other output files
will end up with. The `NAME` should not contain any spaces.

Dependencies
-----
You will need both pandoc and python to use this template.
