include ../../cvstools/Makefile.incl

DRAFT=yes
STYLESHEET=../../xsl/html/docbook.xsl

all: README.html

README.html: README.xml
	$(XJPARSE) $<
	$(XSLT) $< $(STYLESHEET) $@ nochunks=1 draft=$(DRAFT)

