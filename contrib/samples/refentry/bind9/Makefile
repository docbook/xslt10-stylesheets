VERSION=
BASEURL=http://ftp.isc.org/isc/bind9/
SUBDIR=$(VERSION)
DOWNLOAD_FILENAME=bind-$(VERSION).tar.gz 
EXTRACTED_DIR ?= $(basename $(basename $(DOWNLOAD_FILENAME)))
TMP=/tmp
FILE=dig.docbook
MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

WGET=wget
WGETFLAGS=

UNTAR ?= tar
UNTAR_OPTS ?= xvfz

all: man

$(FILE):
ifeq ($(VERSION),)
	@echo 'See http://ftp.isc.org/isc/bind9/'
	@echo 'Specify a VERSION; e.g., "make VERSION=9.4.0b2" to download 9.4.0b2'
	@echo
endif
	(cd $(TMP); $(WGET) $(WGETFLAGS) $(BASEURL)/$(SUBDIR)/$(DOWNLOAD_FILENAME))
	(cd $(TMP); $(UNTAR) $(UNTAR_OPTS) $(DOWNLOAD_FILENAME))
	find $(TMP)/$(EXTRACTED_DIR) -name "*.docbook" -exec cp {} . \;

man: $(FILE)
	$(MAKE) -f $(MAKEFILE_DOCBOOK) man DOCBOOK_FILE_EXTENSION=.docbook

clean:
	$(MAKE) -f $(MAKEFILE_DOCBOOK) clean DOCBOOK_FILE_EXTENSION=.docbook
	$(RM) *.docbook
