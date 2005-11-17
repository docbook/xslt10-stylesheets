# $Id$

DOWNLOAD_URL ?= http://www.kitebird.com/software/xmlformat
DOWNLOAD_FILENAME ?= xmlformat-1.03.tar.gz

EXTRACTED_DIR ?= $(basename $(basename $(DOWNLOAD_FILENAME)))

WGET ?= wget
WGET_OPTS ?=

UNTAR ?= tar
UNTAR_OPTS ?= xvfz

all: $(EXTRACTED_DIR)

$(EXTRACTED_DIR): $(DOWNLOAD_FILENAME)
	$(UNTAR) $(UNTAR_OPTS) $<

$(DOWNLOAD_FILENAME):
	$(WGET) $(DOWNLOAD_URL)/$@

clean:
	$(RM) $(DOWNLOAD_FILENAME)
	$(RM) -r $(EXTRACTED_DIR)

