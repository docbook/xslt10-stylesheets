HOST=https://svn.sourceforge.net
BASE=svnroot/scmxx/trunk
MODULE=scmxx/docs
TMP_SUBDIR=scmxx
FILES=scmxx.de.xml scmxx.en.xml scmxx.it.xml scmxx.ru.xml

TMP ?= /tmp

SVN=svn
SVNFLAGS=

$(FILES):
	(cd $(TMP) \
	  && $(SVN) $(SVNFLAGS) co $(HOST)/$(BASE)/$(MODULE) $(MODULE))
	for file in $(FILES); do cp $(TMP)/$(MODULE)/$$file .; done

clean:
	$(RM) $(FILES)
