VPATH=rnx

TOOLS=../../tools

RNXFILES=$(subst rnx/,,$(wildcard rnx/*.rnx))
RNGFILES=$(subst .rnx,.rng,$(RNXFILES))

AUGMENT=$(TOOLS)/augment.xsl
INCLUDE=$(TOOLS)/include.xsl
CLEANUP=$(TOOLS)/cleanup.pl

.SUFFIXES: .rng .rnx

all: $(RNGFILES)

.rnx.rng:
	saxon $< $(INCLUDE) ,$@ use.extensions=1
	saxon ,$@ $(AUGMENT) $@ use.extensions=1
	perl -i $(CLEANUP) $@
	rm -f ,$@

.rnc.rnx:
	trang -O rng $< $@

clean:
	rm -f *.rng
