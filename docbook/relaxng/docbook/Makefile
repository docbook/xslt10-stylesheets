include ../../../cvstools/Makefile.incl
VPATH=src

.SUFFIXES: .rnc .rng .rnx .dtx .dtd
.PHONY: tests html

RNCFILES=$(wildcard $(VPATH)/*.rnc)
TOOLS=../tools
XSLTPROC=xsltproc

all: docbook.rng docbook.dtd dbforms.rng dbforms.dtd

# ============================================================
#
# N.B. We need an explicit dependency on src/*.rnc for each *.rng
#      file because the build process produces an *output* RNC file
#      in the current directory and that's not the one we want to
#      depend on.
#
#      That's also the reason for the curious sleep/touch pattern
#      in the build rules. We want to make sure that the output RNC
#      file is older than the output RNG file so that make doesn't
#      always think it needs to rebuild the RNG file.
#
#      If we could take "." out of VPATH, we wouldn't need to do this.

docbook.rng: $(RNCFILES)
dbforms.rng: $(RNCFILES)

.rnc.rng:
	$(MAKE) -C build $@
	cp build/$@ .
	$(RUNTRANG) $@ docbook.rnc
	sleep 2
	touch $@

.rng.rnx:
	$(XSLTPROC) -output $@ $(TOOLS)/rngdocxml.xsl $<

.rnx.dtx:
	$(XSLTPROC) -output $@ $(TOOLS)/doc2dtd.xsl $<

.dtx.dtd:
	$(XSLTPROC) -output $@ $(TOOLS)/xml2dtd.xsl $<

# ============================================================

tests:
	mkdir -p tests tests/passed
	cd tests && ../$(TOOLS)/runtests

# ============================================================

clean:
	$(RM) docbook*
	$(RM) dbforms*
	$(MAKE) -C build clean

# EOF
