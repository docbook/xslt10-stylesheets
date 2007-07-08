include ../../releasetools/Variables.mk

PARAM_DIRS=html fo manpages roundtrip slides/fo slides/html website
PI_DIRS=html fo common

PARAM_XML_FILES=$(foreach format,$(PARAM_DIRS),../$(format)/param.xml)
PI_XML_FILES=$(foreach format,$(PI_DIRS),../$(format)/pi.xml)
OTHER_XML_FILES=common.xml template.xml utility.xml pi-fo.xml pi-html.xml pi-common.xml

DOCBOOK_RNG=$(DOCBOOK_SVN)/releasetools/docbook.rng
PARAM_XSL_FILES=$(foreach format,$(PARAM_DIRS),../$(format)/param.xsl)

all: $(PARAM_XML_FILES) $(PI_XML_FILES) $(DOCBOOK_ELEMENTS) $(XSL_PARAMS)

../%/param.xml:
	$(MAKE) -C $(dir $@) param.xml

../%/pi.xml:
	$(MAKE) -C $(dir $@) pi.xml

clean:
	$(RM) $(PARAM_XML_FILES)
	$(RM) $(PI_XML_FILES)
	$(RM) $(OTHER_XML_FILES)

$(DOCBOOK_ELEMENTS): $(MAKE_ELEMENTS_XSL) $(DOCBOOK_RNG)
	$(XSLT) $(DOCBOOK_RNG) $< $@

$(XSL_PARAMS): $(MAKE_PARAMS_XSL) $(PARAM_XSL_FILES)
	$(XSLT) $< $< $@

release-clean: clean
	$(RM) $(DOCBOOK_ELEMENTS)
	$(RM) $(XSL_PARAMS)
