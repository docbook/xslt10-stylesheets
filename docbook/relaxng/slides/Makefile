VPATH=src

.SUFFIXES: .rnc .rng .rnx .dtx .dtd
.PHONY: tests html

DOCBOOK=../docbook
TOOLS=../tools
RNGFILES=$(wildcard build/*.rng)

all: slides.rng slides.dtd slides-full.rng slides-full.dtd

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

slides.rng: src/slides.rnc
slides-full.rng: src/slides-full.rnc

.rnc.rng:
	$(MAKE) -C build $@
	perl $(TOOLS)/trimgrammar.pl -o ,$@ build/$@
	saxon ,$@ $(TOOLS)/trimgrammar.xsl $@ use.extensions=1
	trang $@ `basename $<`
	sleep 2
	touch $@
	rm -f ,$@

.rng.rnx:
	xsltproc -output $@ $(TOOLS)/rngdocxml.xsl $<

.rnx.dtx:
	xsltproc -output $@ $(TOOLS)/doc2dtd.xsl $<

.dtx.dtd:
	xsltproc -output $@ $(TOOLS)/xml2dtd.xsl $<

# ============================================================

clean:
	rm -f slides*
