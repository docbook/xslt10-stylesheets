include ../../cvstools/Makefile.incl

all: xslfiles

include xslfiles.gen

.cvsignore:
	echo .cvsignore > .cvsignore
	echo xslfiles.gen >> .cvsignore
	for f in ../html/*.xsl; do \
	    echo `basename $$f`; \
        done >> .cvsignore

# note: this will break if a file is added to the html directory that occurs
# alphabetically after xref.xsl
xslfiles.list: .cvsignore
	echo -n "xslfiles: " > xslfiles.gen
	for f in `cat .cvsignore`; do \
	    if [ "$$f" != ".cvsignore" -a "$$f" != "xslfiles.gen" ]; then \
	       echo -n `basename $$f`; \
               if [ "$$f" != "xref.xsl" ]; then \
                  echo " \\"; \
               else \
                  echo ""; \
	       fi; \
            fi; \
        done >> xslfiles.gen
	echo "" >> xslfiles.gen
	for f in `cat .cvsignore`; do \
	    if [ "$$f" != ".cvsignore" -a "$$f" != "xslfiles.gen" ]; then \
	       echo `basename $$f`: ../html/`basename $$f`; \
	       echo -n "	$$"; \
	       echo -n "(XSLT) "; \
	       echo -n "$$"; \
	       echo -n "< html2xhtml.xsl "; \
	       echo -n "$$"; \
	       echo "@"; \
	       echo ""; \
	   fi; \
        done >> xslfiles.gen

clean:
	rm -f *~
	for f in *.xsl; do \
	   if [ "$$f" != "html2xhtml.xsl" ]; then \
	      rm -f $$f; \
	   fi; \
	done

#%.xsl: html2xhtml.xsl
#	$(XSLT) ../html/$@ html2xhtml.xsl $@
