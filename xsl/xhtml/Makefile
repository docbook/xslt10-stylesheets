include ../../cvstools/Makefile.incl

all: xslfiles

include xslfiles.gen

.cvsignore:
	for f in ../html/*.xsl; do \
	    echo `basename $$f`; \
        done >> .cvsignore

# note: this will break if a file is added to the html directory that occurs
# alphabetically after xref.xsl
xslfiles.list: .cvsignore
	echo -n "xslfiles: " > xslfiles.gen
	for f in `cat .cvsignore`; do \
	    echo -n `basename $$f`; \
            if [ "$$f" != "xref.xsl" ]; then \
               echo " \\"; \
            else \
               echo ""; \
            fi; \
        done >> xslfiles.gen

%.xsl: html2xhtml.xsl
	$(XSLT) ../html/$@ html2xhtml.xsl $@
