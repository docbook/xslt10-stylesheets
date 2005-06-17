include ../../../cvstools/Makefile.incl

STYLE=../../html/docbook.xsl
VPATH=../../docsrc/tools
XSLTOPT=

HTMLFILES = profiling.html

all: profile-chain.png $(HTMLFILES)

%.html : %.xml $(STYLE)
	$(XSLT) $< $(STYLE) $@ $(XSLTOPT)

profile-chain.png: $(VPATH)
	cp $(VPATH)/profile-chain.png .

clean:
	rm -f $(HTMLFILES)
	rm -f profile-chain.png
