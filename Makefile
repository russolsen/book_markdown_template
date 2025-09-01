# The actual title of the book.
TITLE=A Sample Book

# File name used for the book. No spaces.
NAME=sample

SRCS:=$(wildcard chapters/[0-9]*.md)
EPUB_NAME=$(NAME).epub
EPUB=target/$(EPUB_NAME)
PDF_NAME=$(NAME).pdf
PDF=target/$(PDF_NAME)
RTF=target/$(NAME).rtf
PLAIN=target/$(NAME).txt
TMPDIR=target/temp
WRAPPED=target/$(NAME)_wrapped.txt
DOCX=target/$(NAME).docx
EXPLODED=target/files
CSS_FILES:=pandoc.css
EPUB_SRCS=$(BOOK) $(CSS_FILES)

BOOK_MD=$(TMPDIR)/book.md
BOOK_ADOC=$(TMPDIR)/book.adoc

COVER:=cover.png

default: $(EPUB)

$(TMPDIR):
	mkdir -p $(TMPDIR)


$(TMPDIR)/combined.md: $(TMPDIR) $(SRCS)
	@echo "Generating $@..."
	@./scripts/combine $(SRCS) >$@

$(BOOK_MD): $(TMPDIR)/combined.md
	./scripts/preprocess $< $@ md

$(PDF): $(BOOK_ADOC) $(COVER)
	asciidoctor-pdf -d book -b pdf $(BOOK_ADOC) -o $@

pdf: $(PDF)

$(EPUB): $(BOOK_MD) $(COVER) metadata.yml
	pandoc -t epub3 --toc --metadata-file="metadata.yml" --epub-cover-image=$(COVER) --css pandoc.css -o $@ $(BOOK_MD)

epub: $(EPUB)

test-epub:
	$(MAKE) COVER=test-cover.jpg TITLE="test-$(TITLE)"

$(DOCX): $(BOOK_MD)
	pandoc -t docx --metadata-file="metadata.yml" --epub-cover-image=$(COVER) --css pandoc.css -o $@ $<

docx: $(DOCX)

files: epub pdf

$(BOOK_ADOC): $(TMPDIR)/combined.md header.adoc
	pandoc -t asciidoc $< -o $(TMPDIR)/01.adoc
	@cat header.adoc $(TMPDIR)/01.adoc >$(TMPDIR)/02.adoc
	./scripts/preprocess $(TMPDIR)/02.adoc $@ adoc

wc:
	wc $(SRCS)

$(PLAIN): $(EPUB)
	pandoc -t plain --metadata title="$(TITLE)" -o $@ $<

plain: $(PLAIN)

$(WRAPPED): $(PLAIN)
	python3 scripts/wrap.py < $<  > $@

wrapped: $(WRAPPED)


open_pdf: $(PDF)
	open $<

explode: $(EPUB)
	rm -rf target/files
	mkdir -p target/files/raw
	unzip -d target/files/raw $(EPUB)
	cp -r target/files/raw/EPUB/* target/files

x: explode

lint: $(SRCS)
	vale $(SRCS) 

%-lint: chapters/%*.adoc
	vale $<

css: files
	cat $(EXPLODED)/styles/*

open: $(EPUB)
	open $(EPUB)

debug:
	echo $(EPUB)
	echo $(SRCS)
clean:
	rm -rf target
