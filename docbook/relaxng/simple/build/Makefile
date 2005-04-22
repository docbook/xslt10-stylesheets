VPATH=../src

TOOLS=../../tools

AUGMENT=$(TOOLS)/augment.xsl
INCLUDE=$(TOOLS)/include.xsl
CLEANUP=$(TOOLS)/cleanup.pl

.SUFFIXES: .rng .rnc

all:
	@echo Make what?

.rnc.rng:
	trang -O rng $< $@
	saxon $@ $(INCLUDE) ,$@ use.extensions=1
	saxon ,$@ $(AUGMENT) $@ use.extensions=1
	perl -i $(CLEANUP) $@
	rm -f ,$@

clean:
	rm -f *.rng
