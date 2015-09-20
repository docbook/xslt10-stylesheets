# $Id$

DOWNLOAD_URL ?= http://www.catb.org/~esr/freshmeat-submit
DOWNLOAD_FILENAME ?= freshmeat-submit-1.6.tar.gz

WGET ?= wget
WGET_OPTS ?=

TAR=tar

all: freshmeat-submit-1.6/freshmeat-submit

$(DOWNLOAD_FILENAME):
	$(WGET) $(DOWNLOAD_URL)/$@

freshmeat-submit-1.6/freshmeat-submit: $(DOWNLOAD_FILENAME)
	$(TAR) xvfz $<

clean:
	$(RM) $(DOWNLOAD_FILENAME)
	$(RM) -r freshmeat-submit-1.6
