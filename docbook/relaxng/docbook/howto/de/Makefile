include ../../../../../buildtools/Makefile.incl

HTMLSTYLE=../stylesheets/html.xsl
FOSTYLE=../stylesheets/fo.xsl
# below are customizations layers for XSL-NS stylesheets
HTMLNSSTYLE=../stylesheets/html-ns.xsl
FONSSTYLE=../stylesheets/fo-ns.xsl
VARS=

XMLCATFILE=/etc/xml/catalog
DB=http://docbook.sourceforge.net/release/xsl/current/
DBNS=http://docbook.sourceforge.net/release/xsl-ns/current/
PROFSTYLE=$(shell xmlcatalog ${XMLCATFILE}   ${DB}/profiling/profile.xsl )
PROFNSSTYLE=$(shell xmlcatalog ${XMLCATFILE} ${DBNS}/profiling/profile.xsl )

all: howto.xml howto.html howto.pdf

# output using the namespaced stylesheets
ns: howto.ns.xml howto.ns.html howto.ns.pdf

%.xml :  %.de.xml 
	@echo "Profiling $@ into $<..."
	$(XSLT) $< $(PROFSTYLE) $@ $(VARS) profile.lang=de

%.ns.xml: %.de.xml
	@echo "Profiling $@ into $<..." 
	$(XSLT) $< $(PROFNSSTYLE) $@ $(VARS) profile.lang=de

%.html : %.xml $(HTMLSTYLE)
	jing -c ../../docbook.rnc $<
	$(XSLT) $< $(HTMLSTYLE) $@ $(VARS)

%.ns.html : %.xml $(HTMLNSSTYLE)
	jing -c ../../docbook.rnc $<
	$(XSLT) $< $(HTMLNSSTYLE) $@ $(VARS)

%.fo : %.xml $(FOSTYLE)
	jing -c ../../docbook.rnc $<
	$(XSLT) $< $(FOSTYLE) $@ xep.extensions=1 $(VARS)

%.ns.fo : %.xml $(FONSSTYLE)
	jing -c ../../docbook.rnc $<
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
