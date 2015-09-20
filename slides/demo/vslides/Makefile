include ../../../buildtools/Makefile.incl
SLIDES=../source/slides.xml

index.html: ../../xsl/html/vslides.xsl

	$(XSLT) $(SLIDES) $<

clean:
	rm -f *.html
