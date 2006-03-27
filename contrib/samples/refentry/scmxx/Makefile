HOST=https://svn.sourceforge.net
BASE=svnroot/scmxx/trunk
MODULE=scmxx/docs
TMP_SUBDIR=scmxx
FILES=scmxx.de.xml scmxx.en.xml scmxx.it.xml scmxx.ru.xml docbook-man-utf8.xsl
SCMXX_MAKEFILE=Makefile.in

TMP ?= /tmp

SVN=svn
SVNFLAGS=

all: $(FILES) scmxx.Makefile.in

$(FILES):
	(cd $(TMP) \
	  && $(SVN) $(SVNFLAGS) co $(HOST)/$(BASE)/$(MODULE) $(MODULE))
	for file in $(FILES); do cp $(TMP)/$(MODULE)/$$file .; done
	cp $(TMP)/$(MODULE)/$(SCMXX_MAKEFILE) .

scmxx.Makefile.in: $(FILES)
	mv $(SCMXX_MAKEFILE) $@

clean:
	$(RM) $(FILES)
	$(RM) scmxx.Makefile.in
