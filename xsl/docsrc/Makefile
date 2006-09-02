include ../../cvstools/Makefile.incl
DIRS=common refentry html fo manpages wordml slides website template pi

DOCBOOK5_RNG=../../docbook/relaxng/docbook/docbook.rng
PARAM_XSL_FILES=$(shell for file in $$(find . -name "param.xsl"); do \
	readlink -f $$file; done | grep -v xhtml)

MAKE_ELEMENTS_XSL=make-elements.xsl
MAKE_PARAMS_XSL=make-xsl-params.xsl

all: base docbook-elements.xsl xsl-params.xsl

base:
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
	$(RM) reference.txt
	$(RM) reference.html
	$(RM) reference.fo
	$(RM) reference.pdf

$(DOCBOOK5_RNG):
	$(MAKE) -C $(dir $@) $(notdir $@)

docbook-elements.xsl: $(MAKE_ELEMENTS_XSL) $(DOCBOOK5_RNG)
	$(XSLT) $(DOCBOOK5_RNG) $< $@

xsl-params.xsl: $(MAKE_PARAMS_XSL) $(PARAM_XSL_FILES)
	$(XSLT) $< $< $@

realclean: clean
	$(RM) docbook-elements.xsl
	$(RM) xsl-params.xsl
