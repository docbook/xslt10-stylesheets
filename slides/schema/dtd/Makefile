include ../../../cvstools/Makefile.incl

VERSION=

all: slides.dtd

slides.dtd: slides-custom.dtd slides.mod
	$(FLATTEN) $< > $@

doc: slides.dtd
ifeq ($(VERSION),)
	@echo You must specify the VERSION
else
	dtdparse --title "Slides XML V$(VERSION) DTD" \
                 --output slides.xml \
                 --decl /usr/lib/sgml/declaration/xml.dcl \
                 --public "-//Norman Walsh//DTD Slides XML V$(VERSION)//EN" \
                 --system "http://docbook.sourceforge.net/release/slides/$(VERSION)/schema/dtd/slides.dtd" \
                 --nounexpanded slides.dtd
	dtdformat --html --noentities --nonotations slides.xml
endif

doc-full: slides-full.dtd
ifeq ($(VERSION),)
	@echo You must specify the VERSION
else
	dtdparse --title "Slides Full XML V$(VERSION) DTD" \
                 --output slides-full.xml \
                 --decl /usr/lib/sgml/declaration/xml.dcl \
                 --public "-//Norman Walsh//DTD Slides Full XML V$(VERSION)//EN" \
                 --system "http://docbook.sourceforge.net/release/slides/$(VERSION)/schema/dtd/slides-full.dtd" \
                 --catalog /sourceforge/docbook/catalog \
                 --nounexpanded slides-full.dtd
	dtdformat --html --noentities --nonotations slides-full.xml
endif

clean:
	rm -rf slides slides.xml

