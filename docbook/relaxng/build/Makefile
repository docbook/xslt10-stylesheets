VPATH=../src ../tests/customizations

RNCFILES=$(subst ../src/,,$(wildcard ../src/*.rnc))
RNXFILES=$(subst .rnc,.rnx,$(RNCFILES))
MODULES=$(filter-out docbook.rnx,$(RNXFILES))

TMPDIR=/tmp/
TMPFILE=$(TMPDIR)cleanup.rng
AUGMENT=../tools/augment.xsl
INCLUDE=../tools/include.xsl
EXPAND=../tools/expand.xsl
GROUP=../tools/group.xsl
FLATTEN=../tools/flatten.xsl
CLASSIFY=../tools/classify.xsl
CLEANUP=../tools/cleanup.pl

.SUFFIXES: .rnc .rng .rnx

docbook.rng: docbook.rnx $(AUGMENT) $(INCLUDE) $(CLEANUP)

docbook.rnx: $(MODULES)

dbsmall.rng: dbsmall.rnx $(AUGMENT) $(INCLUDE) $(CLEANUP)

dbsmall.rnx: $(MODULES)

dbastro.rng: dbastro.rnx $(AUGMENT) $(INCLUDE) $(CLEANUP)

dbastro.rnx: $(MODULES)

.rnx.rng:
	saxon $< $(INCLUDE) ,$@ use.extensions=1
	saxon ,$@ $(AUGMENT) $@ use.extensions=1
	perl -i $(CLEANUP) $@
	cp $@ ..

#	rm -f ,$@

.rnc.rnx:
	trang -O rng $< $@

clean:
	rm -f *.rnx *.rng

