PROC=saxon
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
TEXTOPT=
include .tabular
else
STYLESHEET=$(WEBSTYLE)
STYLECHUNK=$(WEBCHUNK)
TEXTOPT=filename-prefix=txt
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
	$(PROC) $(PROCOPT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@ $(TEXTOPT) $(STYLEOPT)
ifeq ($(USETIDY),1)
	-tidy -iq -latin1 -mn $@
endif

# RDDL gets its own rule because we never want to call tidy on it
rddl.html: autolayout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@ $(TEXTOPT) $(STYLEOPT)

depends: autolayout.xml
	xjparse $<
	$(PROC) $(PROCOPT) $< ../xsl/makefile-dep.xsl .tabular
	$(PROC) $(PROCOPT) $< ../xsl/makefile-dep.xsl .textonly prefix=txt
