VPATH=../src

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

all: docbook.rng

docbook.rng: docbook.rnx hier.rnx pool.rnx calstbl.rnx htmltbl.rnx callouts.rnx \
             ebnf.rnx svg.rnx mathml.rnx msgset.rnx htmlform.rnx refentry.rnx \
             tasks.rnx \
	     $(AUGMENT) $(INCLUDE) $(CLEANUP)

.rnx.rng:
	saxon $< $(INCLUDE) $(TMPFILE) use.extensions=1
	saxon $(TMPFILE) $(AUGMENT) $@ use.extensions=1
	perl -i $(CLEANUP) $@

.rnc.rnx:
	trang -O rng $< $@

clean:
	rm -f *.rnx *.rng

