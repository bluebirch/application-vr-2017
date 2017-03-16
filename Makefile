all: bibliography/biblio.bib fulltext.pdf fulltext.docx

fulltext.%: meta.yaml $(shell cat layout.md) refs.md
	pandoc -f markdown -o $@ -F ./authorea-citations-filter --bibliography bibliography/biblio-biblatex.bib --smart --self-contained --latex-engine=xelatex $+

refs:
	bibcheck --sort bibliography/biblio-biblatex.bib
	biber --tool --configfile=bibliography/biblatex-to-bibtex.conf --output-resolve --output-file=bibliography/biblio.bib bibliography/biblio-biblatex.bib

clean:
	rm -f fulltext.*