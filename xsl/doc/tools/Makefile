include ../../../cvstools/Makefile.incl
XSLT=saxon

STYLE=../../html/docbook.xsl
VPATH=../../docsrc/tools

HTMLFILES = profiling.html

all: $(HTMLFILES) profile-chain.png 

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@

profile-chain.png: $(VPATH)
	cp $(VPATH)/profile-chain.png .

clean:
	rm -f $(HTMLFILES)
	rm -f profile-chain.png
