include ../../../cvstools/Makefile.incl

VPATH=../dtd

RDDLNS=http://www.rddl.org/
XLINKNS=http://www.w3.org/1999/xlink
HTMLNS=http://www.w3.org/1999/xhtml

SED=sed
SED_OPTS=-i # edit files in place

RNCFILES=autolayout.rnc layout.rnc website.rnc website-full.rnc website-custom.rnc

all: $(RNCFILES)

autolayout.rng: autolayout.dtd
	$(RUNTRANG) $< $@

layout.rng: layout.dtd
	$(RUNTRANG) $< $@

website-%.rng: website-%.dtd
	$(RUNTRANG) \
	  -i xmlns:rddl=$(RDDLNS) -i xmlns:xlink=$(XLINKNS) -i xmlns:html=$(HTMLNS) \
	  $< $@

website.rng: ../dtd/website.dtd
	$(RUNTRANG) \
	  -i xmlns:rddl=$(RDDLNS) -i xmlns:xlink=$(XLINKNS) -i xmlns:html=$(HTMLNS) \
	  $< $@

../dtd/website.dtd:
	make -C ../dtd

%.rnc: %.rng
	$(RUNTRANG) $< $@
	$(SED) $(SED_OPTS) 's/start \+= \+webpage \+| \+article/start = webpage/' $@

clean:
	rm -f *.rng *.rnc *.dtd
