main:
	pdflatex -synctex=1 --shell-escape main.tex
	pdflatex -synctex=1 --shell-escape main.tex
	pdflatex -synctex=1 --shell-escape main.tex

clean:
	rm -rf main.log main.out main.bbl main.bcf main.blg main.nav main.run.xml main.snm main.toc *aux
