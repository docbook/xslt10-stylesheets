DIRS=common html fo manpages template tools pi

PARAMS=$(shell find ../params/*.xml)

all: xsl-params.xsl $(PARAMS)
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

clean:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
		fi \
	done

xsl-params.xsl: make-xsl-params.pl
	perl $< > $@

realclean: clean
	rm -f xsl-params.xsl
