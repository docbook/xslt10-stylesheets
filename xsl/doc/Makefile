include ../../cvstools/Makefile.incl
XSLTOPT=
PROCOPT=

.PHONY : clean

RSTYLE=reference.xsl
CRSTYLE=creference.xsl
BSTYLE=book.xsl
VPATH=../docsrc

DIRS=common refentry lib html fo manpages wordml slides website tools template pi

all: copyright.html warranty.html reference.html index.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

copyright.html: copyright.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

warranty.html: warranty.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

reference.html: reference.xml $(RSTYLE)
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(RSTYLE) $@ $(XSLTOPT)

index.html: documentation.xml $(BSTYLE) reference.xml \
            publishing.xml extensions.xml templates.xml \
            tools/profiling.xml htmlhelp.xml
	$(XJPARSE) $(VPATH)/$<
	$(XSLT) $(PROCOPT) $< $(BSTYLE) $(XSLTOPT)

clean:
	rm -f *.html
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
		fi \
	done
