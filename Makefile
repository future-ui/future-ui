pdf:
	pandoc --toc --variable version=0.0.1 -N --highlight-style=tango --latex-engine=xelatex --variable mainfont=Helvetica --variable monofont="Meslo LG L DZ" --chapters $(shell ls -d -1 `pwd`/_input/*.*) -o _output/future-ui.pdf
	open -g `pwd`/_output/future-ui.pdf
html:
	pandoc -S -o _output/future-ui.html $(shell ls -d -1 `pwd`/_input/*.*)
epub:
	pandoc -S --epub-metadata.xml -o dist/future-ui.epub $(shell ls -d -1 `pwd`/_input/*.*)
dist: pdf html epub
	@echo "done"
watch:
	watchman watch $(shell echo `pwd`/_input/)
	watchman -- trigger $(shell pwd) remake '**/*.md' -- make pdf
