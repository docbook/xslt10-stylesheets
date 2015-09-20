include ../../buildtools/Makefile.incl

OLDVER=
NEWVER=
FMGO=-N

distrib:
	$(MAKE) -C ../spec SPECVER=$(NEWVER)
	$(DTDDISTRIB) -d -v $(OLDVER) -n $(NEWVER)

freshmeat:
ifeq ($(NEWVER),)
	@echo "You must specify the version (NEWVER)"
else
	$(XSLT) freshmeat.xsl freshmeat.xsl /tmp/fm-docbook-dtd version=$(NEWVER)
	grep -v "<?xml" /tmp/fm-docbook-dtd | freshmeat-submit $(FMGO)
endif

doc:
ifeq ($(NEWVER),)
	@echo "You must specify the version (NEWVER)"
else
	dtdparse --title "DocBook XML V$(NEWVER) DTD" \
                 --output docbookx.xml \
                 --decl /usr/lib/sgml/declaration/xml.dcl \
                 --public "-//OASIS//DTD DocBook XML V$(NEWVER)//EN" \
                 --system "http://docbook.org/xml/$(NEWVER)/docbookx.dtd" \
                 --nounexpanded docbookx.dtd
	dtdformat --html --noentities --nonotations docbookx.xml
endif

clean:
	rm -rf docbookx docbookx.xml
