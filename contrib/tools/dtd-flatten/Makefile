# $Id$

DOWNLOAD_URL ?= http://woodstox.codehaus.org/tools
DOWNLOAD_FILENAME ?= dtd-flatten.jar

WGET ?= wget
WGET_OPTS ?=

all: $(DOWNLOAD_FILENAME)

$(DOWNLOAD_FILENAME):
	$(WGET) $(DOWNLOAD_URL)/$@

clean:
	$(RM) $(DOWNLOAD_FILENAME)

