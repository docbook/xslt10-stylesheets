include ../../cvstools/Makefile.incl

FILE=

all: docbook.xsl
ifneq ($(FILE),)
	$(XSLT) $(FILE) docbook.xsl
endif

docbook.xsl: docbook.sch
	$(XJPARSE) $<
	$(XSLT) $< $(SCHEMATRON-BASIC) $@
