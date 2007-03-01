include ../../../buildtools/Makefile.incl

XSLTPROC=xsltproc
XSLTPROC_OPTS=

HTML2XHTML=../../../xsl/xhtml/html2xhtml.xsl

all: xsl-files

remove-old:
	for f in ../html/*.xsl; do if [ -f `basename $$f` ]; then $(RM) `basename $$f`; fi; done

add-new:
	for f in ../html/*.xsl; do if [ ! -f `basename $$f` ]; then \
          echo $$f; \
          cp $$f .; \
          touch -t 197001010000 `basename $$f`; fi; done

# Oh, come on! It must be possible to do this in Make, but I can't figure out how (ndw)

xsl-files: remove-old add-new
	for f in *.xsl; do if [ ../html/$$f -nt $$f ]; then $(XSLTPROC) $(XSLTPROC_OPTS) $(HTML2XHTML) ../html/$$f > $$f; fi; done

clean: remove-old
