include ../../buildtools/Makefile.incl
all: index.html s5.html slidy.html
	cp ../files ./
	cp ../images ./

index.html: slides.xml
	$(XSLT) $< ${XSLNS}/slides/xhtml/plain.xsl $@

s5.html: slides.xml
	$(XSLT) $< ${XSLNS}/slides/xhtml/s5.xsl $@

slidy.html: slides.xml
	$(XSLT) $< ${XSLNS}/slides/xhtml/slidy.xsl $@

clean:
	rm -f *.html
	rm -rf images files
