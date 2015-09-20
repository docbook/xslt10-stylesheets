include ../../../buildtools/Makefile.incl
SLIDES=../source/slides.xml

toc.html:
	$(XSLT) $(SLIDES) ../../xsl/html/frames.xsl - overlay=0 multiframe=0 dynamic.toc=0 active.toc=0

clean:
	rm -f *.html
