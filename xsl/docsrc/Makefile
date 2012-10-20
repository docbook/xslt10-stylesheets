include $(DOCBOOK_SVN)/releasetools/Variables.mk

XJPARSEFLAGS= -E 0 -w

PARAM_DIRS=html fo manpages roundtrip slides/fo slides/xhtml website
PI_DIRS=html fo manpages common

PARAM_XML_FILES=$(foreach format,$(PARAM_DIRS),../$(format)/param.xml)
PI_XML_FILES=$(foreach format,$(PI_DIRS),../$(format)/pi.xml)
OTHER_XML_FILES=../common/common.xml ../common/utility.xml ../common/refentry.xml ../common/charmap.xml ../template/titlepage.xml ../fo/table.xml

ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
DOCBOOK_RNG=../../releasetools/docbook.rng
else
DOCBOOK_RNG=$(DOCBOOK_SVN)/releasetools/docbook.rng
endif
else
DOCBOOK_RNG=$(DOCBOOK_SVN)/releasetools/docbook.rng
endif
PARAM_XSL_FILES=$(foreach format,$(PARAM_DIRS),../$(format)/param.xsl)
PI_XSL_FILES=$(foreach format,$(PI_DIRS),../$(format)/pi.xsl)

ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
all: $(PARAM_XML_FILES) ../lib/lib.xml $(PI_XML_FILES) $(OTHER_XML_FILES) ../$(DOCBOOK_ELEMENTS) ../$(XSL_PARAMS) ../$(XSL_PI)
else
all: $(PARAM_XML_FILES) ../lib/lib.xml $(PI_XML_FILES) $(OTHER_XML_FILES) $(DOCBOOK_ELEMENTS) $(XSL_PARAMS) $(XSL_PI)
endif
else
all: $(PARAM_XML_FILES) ../lib/lib.xml $(PI_XML_FILES) $(OTHER_XML_FILES) $(DOCBOOK_ELEMENTS) $(XSL_PARAMS) $(XSL_PI)
endif

../%/param.xml: ../%/param.xsl
	$(MAKE) -C $(dir $@) param.xml

../lib/lib.xml: ../lib/lib.xsl
	$(MAKE) -C ../lib lib.xml

%.xml: %.xsl
	$(XSLT) $< $(XSL2JREF) /dev/null output-file=$@.tmp
	$(XJPARSE) $(XJPARSEFLAGS) $@.tmp
	$(XSLT) $@.tmp $(JREF2REFSECT1) $@
	$(RM) $@.tmp

clean:
	$(RM) $(PARAM_XML_FILES)
	$(RM) ../lib/lib.xml
	$(RM) $(PI_XML_FILES)
	$(RM) $(OTHER_XML_FILES)
	$(RM) reference.xml.included

ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
../$(DOCBOOK_ELEMENTS): $(MAKE_ELEMENTS_XSL) $(DOCBOOK_RNG)
else
$(DOCBOOK_ELEMENTS): $(MAKE_ELEMENTS_XSL) $(DOCBOOK_RNG)
endif
else
$(DOCBOOK_ELEMENTS): $(MAKE_ELEMENTS_XSL) $(DOCBOOK_RNG)
endif
	$(XSLT) $(DOCBOOK_RNG) $< $@

ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
../$(XSL_PARAMS): $(MAKE_PARAMS_XSL) $(PARAM_XSL_FILES)
else
$(XSL_PARAMS): $(MAKE_PARAMS_XSL) $(PARAM_XSL_FILES)
endif
else
$(XSL_PARAMS): $(MAKE_PARAMS_XSL) $(PARAM_XSL_FILES)
endif
	$(XSLT) $< $< $@

ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
../$(XSL_PI): $(MAKE_PI_XSL) $(PI_XSL_FILES)
else
$(XSL_PI): $(MAKE_PI_XSL) $(PI_XSL_FILES)
endif
else
$(XSL_PI): $(MAKE_PI_XSL) $(PI_XSL_FILES)
endif
	$(XSLT) $< $< $@

release-clean: clean
	$(RM) $(DOCBOOK_ELEMENTS)
	$(RM) $(XSL_PARAMS)
