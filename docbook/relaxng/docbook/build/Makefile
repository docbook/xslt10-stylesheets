VPATH=../src

RNCFILES=$(subst ../src/,,$(wildcard ../src/*.rnc))

TOOLS=../../tools
AUGMENT=$(TOOLS)/augment.xsl
INCLUDE=$(TOOLS)/include.xsl
CLEANUP=$(TOOLS)/cleanup.pl

.SUFFIXES: .rnc .rng

all: docbook.rng

# Make sure that docbook.rng depends on all the things that could influence
# it. That's *all* the RNC files, not just docbook.rnc, and the stylesheets
# and cleanup script(s).
#
docbook.rng: $(RNCFILES) $(AUGMENT) $(INCLUDE) $(CLEANUP)

.rnc.rng:
	trang -O rng $< $@
	saxon $@ $(INCLUDE) ,$@ use.extensions=1
	saxon ,$@ $(AUGMENT) $@ use.extensions=1
	perl -i $(CLEANUP) $@
	rm -f ,$@

clean:
	rm -f *.rng
