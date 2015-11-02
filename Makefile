#
# $Id: Makefile 279 2008-01-27 16:19:38Z balaji $
#
# Copyright (C) 2006-2007, University of Chicago. All rights reserved.
#

HEADER = paper

TARGETS: $(HEADER).pdf
.PHONY: all clean distclean $(HEADER).pdf

deps = $(wildcard Makefile *.tex *.bib *.sty */*)

$(HEADER).pdf: $(deps)
	@if test ! -z "`which rubber`" ; then \
		TEXMFOUTPUT=`pwd` rubber -f -d $(HEADER) ; \
	else \
		pdflatex $(HEADER) | tee latex.out ; \
		if grep -q '^LaTeX Warning: Citation.*undefined' latex.out; then \
			bibtex $(HEADER); \
			touch .rebuild; \
		fi ; \
		while [ -f .rebuild -o \
			-n "`grep '^LaTeX Warning:.*Rerun' latex.out`" ]; do \
			rm -f .rebuild; \
			pdflatex $(HEADER) | tee latex.out; \
		done ; \
		rm latex.out ; \
	fi

clean:
	@if test "`which rubber`" != "" ; then \
		TEXMFOUTPUT=`pwd` rubber -d --clean $(HEADER) ; \
		rm -f $(HEADER).spl ; \
	else \
		find . \( -name '*.blg' -print \) -or \( -name '*.aux' -print \) -or \
			\( -name '*.bbl' -print \) -or \( -name '*~' -print \) -or \
			\( -name '*.lof' -print \) -or \( -name '*.lot' -print \) -or \
			\( -name '*.toc' -print \) | xargs rm -f ; \
		rm -f $(HEADER).log $(HEADER).pdf $(HEADER).bbl $(HEADER).blg $(HEADER).aux $(HEADER).spl TAGS ; \
	fi
