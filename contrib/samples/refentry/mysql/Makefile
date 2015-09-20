VERSION=5.2
BASEURL=http://svn.mysql.com/svnpublic/mysqldoc
REFMAN=refman-$(VERSION)
REFMANCOMMON=refman-common
COMMON=common

MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

WGET=wget
WGETFLAGS=-r -nH -l 1 --cut-dirs=2

all: $(REFMAN) $(REFMAN)/Makefile $(REFMANCOMMON) $(COMMON)

$(REFMAN):
	$(WGET) $(WGETFLAGS) $(BASEURL)/$(REFMAN)
	$(RM) $(REFMAN)/Makefile
	cp -p $(MAKEFILE_DOCBOOK) $(REFMAN)/Makefile

$(REFMAN)/Makefile:
	cp -p $(MAKEFILE_DOCBOOK) $(REFMAN)/Makefile

$(REFMANCOMMON):
	$(WGET) $(WGETFLAGS) $(BASEURL)/$(REFMANCOMMON)

$(COMMON):
	$(WGET) $(WGETFLAGS) $(BASEURL)/$(COMMON)

clean:
	$(RM) -r $(REFMAN)
	$(RM) -r $(REFMANCOMMON)
	$(RM) -r $(COMMON)
	$(RM) index.html
	$(RM) robots.txt
