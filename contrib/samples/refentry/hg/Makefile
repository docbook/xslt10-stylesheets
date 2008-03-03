BASEURL=http://www.selenic.com/hg/
SUBMODULE=doc

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

TMP ?= /tmp

HG=hg
HGFLAGS=

all: $(SUBMODULE) $(SUBMODULE)/Makefile

$(SUBMODULE):
	(cd $(TMP) && $(RM) -r $(TMP)/hg && $(HG) $(HGFLAGS) clone $(BASEURL))
	echo ".PRECIOUS: %.xml" > $(TMP)/hg/$(SUBMODULE)/Makefile.tmp
	cat $(TMP)/hg/$(SUBMODULE)/Makefile >> $(TMP)/hg/$(SUBMODULE)/Makefile.tmp
	mv $(TMP)/hg/$(SUBMODULE)/Makefile.tmp $(TMP)/hg/$(SUBMODULE)/Makefile
	$(MAKE) -C $(TMP)/hg/$(SUBMODULE)
	$(RM) $(TMP)/hg/$(SUBMODULE)/Makefile
	$(RM) $(TMP)/hg/$(SUBMODULE)/*.1
	$(RM) $(TMP)/hg/$(SUBMODULE)/*.5
	cp -pR $(TMP)/hg/$(SUBMODULE) .

$(SUBMODULE)/Makefile:
	cp $(MAKEFILE_DOCBOOK) $(SUBMODULE)/Makefile

clean:
	$(RM) -r $(SUBMODULE)
