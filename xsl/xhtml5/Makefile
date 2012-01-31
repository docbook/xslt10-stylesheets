include $(DOCBOOK_SVN)/buildtools/Makefile.incl

TARGETNS=http://www.w3.org/1999/xhtml

all: xhtml-docbook.xsl 

xhtml-docbook.xsl: ../xhtml/docbook.xsl
	$(XSLT) $< xhtml2xhtml5.xsl $@

clean: 
	$(RM) xhtml-docbook.xsl 
