include ../../cvstools/Makefile.incl
XSLT=saxon
XSLTOPT=
PROCOPT=

.PHONY : clean

RSTYLE=reference.xsl
BSTYLE=book.xsl
VPATH=../docsrc

DIRS=common lib html fo tools template

all: copyright.html warranty.html reference.html index.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

copyright.html: copyright.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

warranty.html: warranty.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

reference.html: reference.xml $(RSTYLE) lib/lib.xml common/common.xml \
		html/param.xml html/ebnf.xml \
		fo/param.xml fo/table.xml
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

index.html: documentation.xml $(BSTYLE) reference.xml
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(BSTYLE) $@ $(XSLTOPT)

clean:
	rm -f *.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
		fi \
	done
