VPATH=src

AUGMENT=tools/augment.xsl
CLEANUP=tools/cleanup.pl
TMPFILE=/tmp/cleanup

.SUFFIXES: .rnc .rng .rnx

all: docbook.rng

docbook.rng: docbook.rnx hier.rnx pool.rnx

dbmsg.rng: dbmsg.rnx hier.rnx pool.rnx msgset.rnx

.rnx.rng:
	saxon $< $(AUGMENT) $(TMPFILE) src=$< use.extensions=1
	@for f in `cat $(TMPFILE)`; do perl -i $(CLEANUP) $$f; done

.rnc.rnx:
	trang -O rng $< $@

