.PHONY : clean

RSTYLE=reference.xsl
BSTYLE=book.xsl
VPATH=../docsrc
SAXVER=-6

all: copyright.html warranty.html reference.html index.html
	cd common; make
	cd lib; make
	cd html; make
	cd fo; make

copyright.html: copyright.xml $(RSTYLE)
	xnsgmls -sv -E 5 -c /share/doctypes/catalog $(VPATH)/$<
	saxon $(SAXVER) $< $(RSTYLE) $@

warranty.html: warranty.xml $(RSTYLE)
	xnsgmls -sv -E 5 -c /share/doctypes/catalog $(VPATH)/$<
	saxon $(SAXVER) $< $(RSTYLE) $@

reference.html: reference.xml $(RSTYLE) lib/lib.xml common/common.xml \
		html/param.xml html/ebnf.xml \
		fo/param.xml fo/table.xml
	xnsgmls -sv -E 5 -c /share/doctypes/catalog $(VPATH)/$<
	saxon $(SAXVER) $< $(RSTYLE) $@

index.html: documentation.xml $(BSTYLE) reference.xml
	xnsgmls -sv -E 5 -c /share/doctypes/catalog $(VPATH)/$<
	saxon $(SAXVER) $< $(BSTYLE) $@

clean:
	rm -f *.html common/*.html lib/*.html html/*.html fo/*.html
