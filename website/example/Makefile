include ../../cvstools/Makefile.incl
XSLTOPT=-q
TABSTYLE=../xsl/tabular.xsl
WEBSTYLE=../xsl/website.xsl
TABCHUNK=../xsl/chunk-tabular.xsl
WEBCHUNK=../xsl/chunk-website.xsl
DESTPATH=.
TEXTONLY=0
USETIDY=1

.PHONY : clean

all:
	$(MAKE) website
	$(MAKE) TEXTONLY=1 website

ifeq ($(TEXTONLY),0)
STYLESHEET=$(TABSTYLE)
STYLECHUNK=$(TABCHUNK)
TEXTOPT=
include depends.tabular
else
STYLESHEET=$(WEBSTYLE)
STYLECHUNK=$(WEBCHUNK)
TEXTOPT=filename-prefix=txt
include depends.textonly
endif

autolayout.xml: layout.xml
	$(XJPARSE) $(filter-out autolayout.xml,$^)
	$(XSLT) $(XSLTOPT) $< ../xsl/autolayout.xsl $@

chunk: autolayout.xml
	$(XSLT) $(XSLTOPT) autolayout.xml $(STYLECHUNK) - output-root=$(DESTPATH)

%.html: autolayout.xml 
	$(XJPARSE) $(filter-out autolayout.xml,$^)
	$(XSLT) $(XSLTOPT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@ $(TEXTOPT) $(STYLEOPT)
ifeq ($(USETIDY),1)
	-$(TIDY) -iq -latin1 -mn $@
endif

# RDDL gets its own rule because we never want to call tidy on it
rddl.html: autolayout.xml
	$(XJPARSE) $(filter-out autolayout.xml,$^)
	$(XSLT) $(XSLTOPT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@ $(TEXTOPT) $(STYLEOPT)

depends.tabular: autolayout.xml
	$(XJPARSE) $<
	$(XSLT) $(XSLTOPT) $< ../xsl/makefile-dep.xsl $@

depends.textonly: autolayout.xml
	$(XJPARSE) $<
	$(XSLT) $(XSLTOPT) $< ../xsl/makefile-dep.xsl $@ prefix=txt

website.database.xml: autolayout.xml
	$(XJPARSE) $<
	$(XSLT) $(XSLTOPT) $< ../xsl/website-targets.xsl $@

depends: depends.tabular depends.textonly website.database.xml

realclean: clean
	rm -f depends.tabular depends.textonly website.database.xml autolayout.xml
