VPATH=src

COMBINE=tools/combine.xsl
CLEANUP=tools/cleanup.pl
TEMP1=/tmp/temp1.rng
TEMP2=/tmp/temp2.rng

MODULES=docbook.rnx pool.rnx hier.rnx \
        calstbl.rnx htmltbl.rnx \
        callouts.rnx msgset.rnx \
        mathml.rnx

.SUFFIXES: .rnc .rnx .rng

all: docbook.rng

docbook.rng: $(MODULES)
	saxon $< $(COMBINE) $(TEMP1) modules="$(filter-out $<,$^)" use.extensions=1
	perl $(CLEANUP) < $(TEMP1) > $@
	-rm -f $(TEMP1)

small.rng: docbook.rnx pool.rnx hier.rnx
	saxon $< $(COMBINE) $(TEMP1) modules="$(filter-out $<,$^)" use.extensions=1
	perl $(CLEANUP) < $(TEMP1) > $@
	-rm -f $(TEMP1)

.rnc.rnx:
	trang -O rng $< $@

