# $Id$

DOWNLOAD_URL ?= http://www.jenitennison.com/xslt/utilities
DOWNLOAD_FILENAME ?= markup.xsl

WGET ?= wget
WGET_OPTS ?=

XSLTPROC=xsltproc
XSLTPROCFLAGS=

MODIFY_XSL=modify.xsl

all: modified-$(DOWNLOAD_FILENAME)

$(DOWNLOAD_FILENAME):
	$(WGET) $(DOWNLOAD_URL)/$@

modified-$(DOWNLOAD_FILENAME): $(DOWNLOAD_FILENAME)
	$(XSLTPROC) $(XSLTPROCFLAGS) $(MODIFY_XSL) $< > $@

clean:
	$(RM) $(DOWNLOAD_FILENAME)
	$(RM) modified-$(DOWNLOAD_FILENAME)

