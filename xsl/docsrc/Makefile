include ../../releasetools/Variables.mk

XJPARSEFLAGS= -E 0 -w

PARAM_DIRS=html fo manpages roundtrip slides/fo slides/html website
PI_DIRS=html fo manpages common

PARAM_XML_FILES=$(foreach format,$(PARAM_DIRS),../$(format)/param.xml)
PI_XML_FILES=$(foreach format,$(PI_DIRS),../$(format)/pi.xml)
OTHER_XML_FILES=../common/common.xml ../common/utility.xml ../common/refentry.xml ../common/charmap.xml ../template/titlepage.xml ../fo/table.xml

DOCBOOK_RNG=$(DOCBOOK_SVN)/releasetools/docbook.rng
PARAM_XSL_FILES=$(foreach format,$(PARAM_DIRS),../$(format)/param.xsl)
PI_XSL_FILES=$(foreach format,$(PI_DIRS),../$(format)/pi.xsl)

all: $(PARAM_XML_FILES) ../lib/lib.xml $(PI_XML_FILES) $(OTHER_XML_FILES) $(DOCBOOK_ELEMENTS) $(XSL_PARAMS) $(XSL_PI)

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

$(DOCBOOK_ELEMENTS): $(MAKE_ELEMENTS_XSL) $(DOCBOOK_RNG)
	$(XSLT) $(DOCBOOK_RNG) $< $@

$(XSL_PARAMS): $(MAKE_PARAMS_XSL) $(PARAM_XSL_FILES)
	$(XSLT) $< $< $@

$(XSL_PI): $(MAKE_PI_XSL) $(PI_XSL_FILES)
	$(XSLT) $< $< $@

release-clean: clean
	$(RM) $(DOCBOOK_ELEMENTS)
	$(RM) $(XSL_PARAMS)
