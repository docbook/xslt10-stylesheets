include ../../../cvstools/Makefile.incl
XSLT=xt

STYLE=../jrefhtml.xsl
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
