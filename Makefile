# Set this to the basename of the .tex file
# This will also be the name of the generated .dvi, .ps and .pdf files
PAPER = fortifying_the_java_sandbox

# Set this to the other source files that should be counted as 
# dependencies
OTHERSOURCES := myref.sty references.bib

FIGURES := most_targeted_apps_ibm_xforce.pdf \
	sandbox_overview.pdf 

.PHONY: pdf
pdf: $(PAPER).pdf

%.pdf: %.tex $(OTHERSOURCES) $(FIGURES)
# Remove the .aux file because pdflatex wants it different
	rm -f $*.aux 
	if pdflatex $*.tex </dev/null; then \
		true; \
	else \
		stat=$$?; touch $*.pdf; exit $$stat; \
	fi
	bibtex $(PAPER)
	while grep "Rerun to get cross" $*.log; do \
		if pdflatex $*.tex </dev/null; then \
			true; \
		else \
			stat=$$?; touch $*.pdf; exit $$stat; \
		fi; \
	done

clean:
	rm -f *.aux *.log $(PAPER).ps *.dvi *.blg *.bbl *.toc *~ *.out $(PAPER).pdf
