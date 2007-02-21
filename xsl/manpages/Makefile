include ../../cvstools/Makefile.incl

XSLFILES=param.xsl html-synop.xsl
ALLTARGETS=$(XSLFILES)
PROFILECONDITION=manpages
HTML2ROFF=../tools/xsl/build/html2roff.xsl

include ../Makefile.incl

html-synop.xsl: ../html/synop.xsl
	$(XSLT) $< $(HTML2ROFF) $@
