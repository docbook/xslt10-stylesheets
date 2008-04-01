BASEURL=http://hg.debian.org/hg/aptitude/head
SUBMODULE=doc

TMP ?= /tmp

HG=hg
HGFLAGS=

PATCHFILE=patch.smith.manpage.xml.1

all: $(SUBMODULE)

$(TMP)/aptitude/doc: $(PATCHFILE)
	$(RM) -r $(TMP)/aptitude
	(cd $(TMP) \
	  && $(HG) $(HGFLAGS) clone $(BASEURL) aptitude \
	  && cd aptitude \
	  && ./autogen.sh)
	cp $< $@/en
	(cd $@/en && patch -p0 < $(PATCHFILE))
	make -C $@

$(SUBMODULE): $(TMP)/aptitude/doc
	cp -pR $< $@

clean:
	$(RM) -r $(SUBMODULE)
	$(RM) -r $(TMP)/aptitude
