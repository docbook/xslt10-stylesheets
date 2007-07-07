include ../../releasetools/Variables.mk

PARAM_DIRS=html fo manpages roundtrip slides/fo slides/html website

PARAM_XML_FILES=$(foreach format,$(PARAM_DIRS),../$(format)/param.xml)
OTHER_XML_FILES=common.xml template.xml utility.xml pi-fo.xml pi-html.xml

DOCBOOK_RNG=$(DOCBOOK_SVN)/releasetools/docbook.rng
PARAM_XSL_FILES=$(foreach format,$(PARAM_DIRS),../$(format)/param.xsl)

all: $(PARAM_XML_FILES) $(DOCBOOK_ELEMENTS) $(XSL_PARAMS)

debug:
	@echo $(PARAM_XML_FILES)
	@echo $(PARAM_XSL_FILES)

#$(foreach param,$(shell grep "<xsl:param name" %/param.xsl | sed -r "s;^<xsl:param name=\"([^\"]+)\".+$$;\1;"),../$(param).xml)

../%/param.xml:
	$(MAKE) -C $(dir $@) param.xml

clean:
	$(RM) $(PARAM_XML_FILES)
	$(RM) $(OTHER_XML_FILES)

$(DOCBOOK_ELEMENTS): $(MAKE_ELEMENTS_XSL) $(DOCBOOK_RNG)
	$(XSLT) $(DOCBOOK_RNG) $< $@

$(XSL_PARAMS): $(MAKE_PARAMS_XSL) $(PARAM_XSL_FILES)
	$(XSLT) $< $< $@

release-clean: clean
	$(RM) $(DOCBOOK_ELEMENTS)
	$(RM) $(XSL_PARAMS)
