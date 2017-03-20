bib=bibliography/biblio.bib

auxbib=bibliography/eva.bib

all: $(bib) fulltext.pdf Publikationslista.pdf

fulltext.%: meta.yaml $(shell cat layout.md) refs.md
	pandoc -f markdown -o $@ -F bin/authorea-citations-filter --bibliography $(bib) --number-sections --smart --self-contained --latex-engine=xelatex $+

fulltext.md: meta.yaml $(shell cat layout.md) refs.md
	pandoc -f markdown -t markdown -o $@ -F bin/authorea-citations-filter $+

Publikationslista.pdf: Publikationslista.md
	pandoc -f markdown -o $@ --smart --latex-engine=xelatex $<

refs:
	for bib in $(bib) $(auxbib) ; do\
		cp -av $$bib tmp.bib ;\
		cat tmp.bib | bibtool --preserve.key.case=on --print.line.length=9999 --print.align.key=0 --print.use.tab=off --symbol.type=lower --delete.field={timestamp} -s -r sort_fld.rsc -r improve.rsc > $$bib ;\
	done

# --"new.format.type {17=\"\%f\%v\%l\%j\"}"

clean:
	rm -f fulltext.*

push:
	git add -u
	git commit -m"Commit of offline edits."
	git push