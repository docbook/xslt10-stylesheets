BASEURL=http://hg.sharesource.org/asciidoc
SUBMODULE=doc

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

TMP ?= /tmp

HG=hg
HGFLAGS=

all: $(SUBMODULE) $(SUBMODULE)/Makefile

$(SUBMODULE):
	(cd $(TMP) && $(RM) -r $(TMP)/asciidoc && $(HG) $(HGFLAGS) clone $(BASEURL))
	$(RM) $(TMP)/asciidoc/$(SUBMODULE)/faq.txt
	cp -pR $(TMP)/asciidoc/$(SUBMODULE) .

$(SUBMODULE)/Makefile:
	cp $(MAKEFILE_DOCBOOK) $(SUBMODULE)/Makefile

clean:
	$(RM) -r $(SUBMODULE)
