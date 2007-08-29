include ../../../../buildtools/Makefile.incl

HTMLSTYLE=stylesheets/html.xsl
FOSTYLE=stylesheets/fo.xsl
# below are customizations layers for XSL-NS stylesheets
HTMLNSSTYLE=stylesheets/html-ns.xsl
FONSSTYLE=stylesheets/fo-ns.xsl
VARS=

all: howto.html howto.pdf

# output using the namespaced stylesheets
ns: howto.ns.html howto.ns.pdf

%.html : %.xml $(HTMLSTYLE)
	jing -c ../docbook.rnc $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(VARS)

%.ns.html : %.xml $(HTMLNSSTYLE)
	jing -c ../docbook.rnc $<
	$(XSLT) $< $(HTMLNSSTYLE) $@ $(VARS)

%.fo : %.xml $(FOSTYLE)
	jing -c ../docbook.rnc $<
	$(XSLT) $< $(FOSTYLE) $@ xep.extensions=1 $(VARS)

%.ns.fo : %.xml $(FONSSTYLE)
	jing -c ../docbook.rnc $<
	$(XSLT) $< $(FONSSTYLE) $@ xep.extensions=1 $(VARS)

%.pdf : %.fo
	xep $<

%.ns.pdf : %.ns.fo
	xep $<

clean:
	$(RM) howto.html
	$(RM) howto.pdf
	$(RM) howto.ns.html
	$(RM) howto.ns.pdf
