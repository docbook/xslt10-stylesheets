VPATH=../../src

RNCFILES=$(subst ../../src/,,$(wildcard ../../src/*.rnc))
RNXFILES=$(subst .rnc,.rnx,$(RNCFILES))

.SUFFIXES: .rnc .rnx

all: $(RNXFILES)
	echo "Made $(RNXFILES)"
	echo "From $(RNCFILES)"

.rnc.rnx:
	trang -O rng $< $@

clean:
	rm -f *.rnx *.rng
