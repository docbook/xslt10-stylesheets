include ../../../cvstools/Makefile.incl

ifeq ($(RUNTRANG),)
$(error Cannot find "runtrang" script. Please do a "cvs update" of your cvstools directory)
endif

VPATH=../dtd

RDDLNS=http://www.rddl.org/
XLINKNS=http://www.w3.org/1999/xlink
HTMLNS=http://www.w3.org/1999/xhtml

SED=sed
SED_OPTS=-i # edit files in place

all: autolayout.rng layout.rng website.rng website-full.rng

autolayout.rnc: autolayout.dtd
	$(RUNTRANG) $< $@

layout.rnc: layout.dtd
	$(RUNTRANG) $< $@

website-full.rnc: website-full.dtd
	$(RUNTRANG) \
	  -i xmlns:rddl=$(RDDLNS) -i xmlns:xlink=$(XLINKNS) -i xmlns:html=$(HTMLNS) \
	  $< $@

website.rnc: ../dtd/website.dtd
	$(RUNTRANG) \
	  -i xmlns:rddl=$(RDDLNS) -i xmlns:xlink=$(XLINKNS) -i xmlns:html=$(HTMLNS) \
	  $< $@
	$(SED) $(SED_OPTS) 's/start \+= \+webpage \+| \+article/start = webpage/' $@

../dtd/website.dtd:
	$(MAKE) -C ../dtd

%.rng: %.rnc
	$(RUNTRANG) $< $@

clean:
	rm -f \
	autolayout.rnc autolayout.rng\
	layout.rnc layout.rng \
	website.rnc website.rng \
	website-full.rnc website-full.rng \
	calstblx.rnc calstblx.rng \
	docbookx.rnc docbookx.rng \
	dbhierx.mod.rnc dbhierx.mod.rng \
	dbpoolx.mod.rnc dbpoolx.mod.rng \
	extensions.mod.rnc extensions.mod.rng \
	forms.mod.rnc forms.mod.rng \
	htmltblx.mod.rnc htmltblx.mod.rng \
	namespaces.mod.rnc namespaces.mod.rng \
	rddl.mod.rnc rddl.mod.rng \
	website.mod.rnc website.mod.rng

realclean: clean
