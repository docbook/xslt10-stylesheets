XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

.PHONY : clean

RSTYLE=reference.xsl
BSTYLE=book.xsl
VPATH=../docsrc
SAXVER=-6

DIRS=common lib html fo

all: copyright.html warranty.html reference.html index.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

copyright.html: copyright.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(SAXVER) $< $(RSTYLE) $@

warranty.html: warranty.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(SAXVER) $< $(RSTYLE) $@

reference.html: reference.xml $(RSTYLE) lib/lib.xml common/common.xml \
		html/param.xml html/ebnf.xml \
		fo/param.xml fo/table.xml
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(SAXVER) $< $(RSTYLE) $@

index.html: documentation.xml $(BSTYLE) reference.xml
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(SAXVER) $< $(BSTYLE) $@

clean:
	rm -f *.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
		fi \
	done
