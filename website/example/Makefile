PROC=xsltproc
PROCOPT=-q
TABSTYLE=../xsl/tabular.xsl
WEBSTYLE=../xsl/website.xsl
TABCHUNK=../xsl/chunk-tabular.xsl
WEBCHUNK=../xsl/chunk-website.xsl
DESTPATH=.
TEXTONLY=0
USETIDY=1

.PHONY : clean

all:
	make website
	make TEXTONLY=1 website

ifeq ($(TEXTONLY),0)
STYLESHEET=$(TABSTYLE)
STYLECHUNK=$(TABCHUNK)
STYLEOPT=
include .tabular
else
STYLESHEET=$(WEBSTYLE)
STYLECHUNK=$(WEBCHUNK)
STYLEOPT=filename-prefix=txt
include .textonly
endif

autolayout.xml: layout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $< ../xsl/autolayout.xsl $@
	make depends

chunk: autolayout.xml
	$(PROC) $(PROCOPT) autolayout.xml $(STYLECHUNK) - output-root=$(DESTPATH)

%.html: autolayout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@ $(STYLEOPT)
ifeq ($(USETIDY),1)
	-tidy -iq -latin1 -mn $@
endif

depends: autolayout.xml
	xjparse $<
	$(PROC) $(PROCOPT) $< ../xsl/makefile-dep.xsl .tabular
	$(PROC) $(PROCOPT) $< ../xsl/makefile-dep.xsl .textonly prefix=txt
