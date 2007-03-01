include ../../buildtools/Makefile.incl

XSLFILES=param.xsl
ALLTARGETS=base $(XSLFILES)
PROFILECONDITION=slides
CLEANTARGETS=base-clean
DIRS = fo xhtml

include ../Makefile.incl

.PHONY: fo xhtml

base:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

base-clean:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
		fi \
	done
