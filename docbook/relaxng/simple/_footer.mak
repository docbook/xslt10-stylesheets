# -*- Makefile -*-

$(_MODULE)_OBJS := $(addsuffix .rng,$(addprefix $($(_MODULE)_OUTPUT)/,$(basename $(SRCS))))

$(_MODULE)_BINARY := $($(_MODULE)_OUTPUT)/$(BINARY)

.PRECIOUS: $($(_MODULE)_OBJS)

$($(_MODULE)_OUTPUT)/%.rng: $(_MODULE)/%.rnc $($(_MODULE)_OUTPUT)/.f
	$(RUNTRANG) $< $@

$($(_MODULE)_OUTPUT)/%.rnx: $($(_MODULE)_OBJS) $($(_MODULE)_OUTPUT)/.f $(INCLUDE) $(AUGMENT) $(CLEANUP)
	$(XSLT) $< $(INCLUDE) $@, use.extensions=1
	$(XSLT) $@, $(AUGMENT) $@ use.extensions=1
	$(PERL) $(CLEANUP) $@ > $@,
	$(MV) $@, $@

#$($(_MODULE)_OUTPUT)/%.rng: $(_MODULE)/%.rnc $($(_MODULE)_OUTPUT)/.f
#	$(RUNTRANG) $< $@
#
#$($(_MODULE)_OUTPUT)/%.rng: $($(_MODULE)_OBJS) $($(_MODULE)_OUTPUT)/.f
#	@echo build $< $@
#	$(XSLT) $< $(INCLUDE) $@, use.extensions=1
#	$(XSLT) $@, $(AUGMENT) $@ use.extensions=1
#	$(PERL) -i $(CLEANUP) $@
#	$(RM) $@,

#$($(_MODULE)_OUTPUT)/%.rnx: $($(_MODULE)_OUTPUT)/%.rne
#	$(XSLT) $< $(INCLUDE) $@, use.extensions=1
#	$(XSLT) $@, $(AUGMENT) $@ use.extensions=1
#	$(PERL) -i $(CLEANUP) $@
#	$(RM) $@,

$($(_MODULE)_OUTPUT)/%.rnd: $($(_MODULE)_OUTPUT)/%.rnx $(TOOLS)/rngdocxml.xsl
	$(XSLTPROC) -output $@ $(TOOLS)/rngdocxml.xsl $<

$($(_MODULE)_OUTPUT)/%.dtx: $($(_MODULE)_OUTPUT)/%.rnd $(TOOLS)/doc2dtd.xsl
	$(XSLTPROC) -output $@ $(TOOLS)/doc2dtd.xsl $<

all:: $($(_MODULE)_BINARY)

$(_MODULE): $($(_MODULE)_BINARY)
