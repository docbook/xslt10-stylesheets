include ../../cvstools/Makefile.incl

OLDVER=
NEWVER=

distrib:
	$(MAKE) -C ../spec SPECVER=$(NEWVER)
	$(DTDDISTRIB) -d -v $(OLDVER) -n $(NEWVER)

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
