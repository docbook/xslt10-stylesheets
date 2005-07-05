DIRS=common refentry html fo manpages slides/html website template tools pi

all: xsl-params.xsl
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
