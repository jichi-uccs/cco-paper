# Makefile for the paper
# 2013/3
# use "make" or "make -B" to generate the paper

LATEX = pdflatex
BIBTEX = bibtex

all: paper.pdf clean

paper.pdf: $(wildcard Makefile *.tex *.bib *.sty */*)

%.pdf: %.tex
	$(LATEX) $< || (rm -f $@; exit 1)
	$(LATEX) $< || (rm -f $@; exit 1)
	$(BIBTEX) $(basename $<)  # || (rm -f $@; exit 1)
	$(LATEX) $< || (rm -f $@; exit 1)
	$(BIBTEX) $(basename $<)  # || (rm -f $@; exit 1)
	$(LATEX) $< || (rm -f $@; exit 1)

clean:
	rm -f *.{aux,blg,log,out}

paper.detex.txt: paper.tex
	> $@ detex $^
paper.diction.txt: paper.detex.txt
	> $@ diction -bs $^

# EOF
