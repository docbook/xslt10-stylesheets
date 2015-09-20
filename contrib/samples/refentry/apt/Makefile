MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook
SUBMODULE = doc

TMP ?= /tmp

APTGET = apt-get
APTGETFLAGS =

all: $(SUBMODULE) $(SUBMODULE)/Makefile

$(SUBMODULE):
	(cd $(TMP) && $(APTGET) $(APTGETFLAGS) source apt)
	$(RM) $(TMP)/apt-*/$(SUBMODULE)/Makefile
	$(RM) $(TMP)/apt-*/$(SUBMODULE)/makefile
	$(RM) $(TMP)/apt-*/$(SUBMODULE)/*.?
	cp -pR $(TMP)/apt-*/$(SUBMODULE) .

$(SUBMODULE)/Makefile:
	cp $(MAKEFILE_DOCBOOK) $(SUBMODULE)/Makefile

clean:
	$(RM) -r $(SUBMODULE)
