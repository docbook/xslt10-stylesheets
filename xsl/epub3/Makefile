include $(DOCBOOK_SVN)/buildtools/Makefile.incl

TARGETNS=http://www.w3.org/1999/xhtml

titlepage.templates.xsl: titlepage.templates.xml $(NESTLEVEL)../template/titlepage.xsl
	$(XSLT) $< $(NESTLEVEL)../template/titlepage.xsl $@ ns=$(TARGETNS)

clean:
	rm titlepage.templates.xsl