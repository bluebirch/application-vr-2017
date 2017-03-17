bib=bibliography/biblio.bib

all: $(bib) fulltext.pdf fulltext.docx

fulltext.%: meta.yaml $(shell cat layout.md) refs.md
	pandoc -f markdown -o $@ -F bin/authorea-citations-filter --bibliography $(bib) --number-sections --smart --self-contained --latex-engine=xelatex $+

refs:
	bibtool -- preserve.key.case=on -- print.line.length=9999 -- print.align.key=0 -- symbol.type=lower -s -i $(bib) -o bibliography/tmp.bib
	#mv bibliography/tmp.bib $(bib)

clean:
	rm -f fulltext.*

push:
	git add -u
	git commit -m"Commit of offline edits."
	git push