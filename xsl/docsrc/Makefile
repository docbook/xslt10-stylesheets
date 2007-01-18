include ../../releasetools/Variables.mk
DIRS=common refentry html fo manpages roundtrip slides website template

DOCBOOK5_RNG=../../docbook/relaxng/docbook/docbook.rng
PARAM_XSL_FILES=$(shell for file in $$(find .. -name "param.xsl"); do \
	readlink -f $$file; done | grep -v xhtml)

all: base $(DOCBOOK_ELEMENTS) $(XSL_PARAMS)

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

$(DOCBOOK5_RNG):
	$(MAKE) -C $(dir $@) $(notdir $@)

$(DOCBOOK_ELEMENTS): $(MAKE_ELEMENTS_XSL) $(DOCBOOK5_RNG)
	$(XSLT) $(DOCBOOK5_RNG) $< $@

$(XSL_PARAMS): $(MAKE_PARAMS_XSL) $(PARAM_XSL_FILES)
	$(XSLT) $< $< $@

release-clean: clean
	$(RM) $(DOCBOOK_ELEMENTS)
	$(RM) $(XSL_PARAMS)
