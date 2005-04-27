include ../../../cvstools/Makefile.incl

ifeq ($(RUNTRANG),)
$(error Cannot find "runtrang" script. Please do a "cvs update" of your cvstools directory)
endif

VPATH=../dtd

SED=sed
SED_OPTS=-i # edit files in place

all: slides.rng slides-full.rng

slides-full.rnc: slides-full.dtd
	$(RUNTRANG) $< $@

slides.rnc: ../dtd/slides.dtd
	$(RUNTRANG) $< $@

../dtd/slides.dtd:
	$(MAKE) -C ../dtd

%.rng: %.rnc
	$(RUNTRANG) $< $@

clean:
	rm -f \
	slides.rnc slides.rng \
	slides-full.rnc slides-full.rng \
	calstblx.rnc calstblx.rng \
	docbookx.rnc docbookx.rng \
	dbhierx.mod.rnc dbhierx.mod.rng \
	dbnotnx.mod.rnc dbnotnx.mod.rng \
	dbpoolx.mod.rnc dbpoolx.mod.rng \
	htmltblx.mod.rnc htmltblx.mod.rng \
	slides.mod.rnc slides.mod.rng
