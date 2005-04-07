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

all: autolayout.rnc layout.rnc website.rnc website-full.rnc

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

clean:
	rm -f \
	autolayout.rnc \
	layout.rnc \
	website.rnc \
	website-full.rnc \
	calstblx.rnc \
	docbookx.rnc \
	dbhierx.mod.rnc \
	dbpoolx.mod.rnc \
	extensions.mod.rnc \
	forms.mod.rnc \
	htmltblx.mod.rnc \
	namespaces.mod.rnc \
	rddl.mod.rnc \
	website.mod.rnc
