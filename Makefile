bib=bibliography/biblio.bib

all: $(bib) fulltext.pdf

fulltext.%: meta.yaml $(shell cat layout.md) refs.md
	pandoc -f markdown -o $@ -F bin/authorea-citations-filter --bibliography $(bib) --number-sections --smart --self-contained --latex-engine=xelatex $+

fulltext.md: meta.yaml $(shell cat layout.md) refs.md
	pandoc -f markdown -t markdown -o $@ -F bin/authorea-citations-filter $+

refs:
	cp -av $(bib) tmp.bib
	cat tmp.bib | bibtool --preserve.key.case=on --print.line.length=9999 --print.align.key=0 --print.use.tab=off --symbol.type=lower -s -r sort_fld.rsc > $(bib)

# --"new.format.type {17=\"\%f\%v\%l\%j\"}"

clean:
	rm -f fulltext.*

push:
	git add -u
	git commit -m"Commit of offline edits."
	git push