include ../../../cvstools/Makefile.incl
SLIDES=../source/slides.xml

toc.html:
	$(XSLT) $(SLIDES) ../../xsl/html/frames.xsl - overlay=0 multiframe=1 dynamic.toc=1 active.toc=1

clean:
	rm -f *.html
