VERSION=
HOST=kernel.org
DIR=/pub/linux/utils/kernel/hotplug
DOWNLOAD_FILENAME=udev-$(VERSION).tar.gz
EXTRACTED_DIR ?= $(basename $(basename $(DOWNLOAD_FILENAME)))
TMP=/tmp
FILE=udev.xml
MAKEFILE_DOCBOOK = ../../../../xsl/tools/make/Makefile.DocBook

FTP=lftp
FTP_OPTS=-e

UNTAR ?= tar
UNTAR_OPTS ?= xvfz

all: man

$(FILE):
ifeq ($(VERSION),)
	@echo 'See http://www.us.kernel.org/pub/linux/utils/kernel/hotplug/'
	@echo 'Specify a VERSION; e.g., "make VERSION=103" to download udev-103.tar.bz2'
	@echo
endif
	$(FTP) $(FTP_OPTS) "mget -O $(TMP) $(DIR)/$(DOWNLOAD_FILENAME); quit" $(HOST)
	(cd $(TMP); $(UNTAR) $(UNTAR_OPTS) $(DOWNLOAD_FILENAME))
	cp $(TMP)/$(EXTRACTED_DIR)/*.xml .

man: $(FILE)
	make -f $(MAKEFILE_DOCBOOK) man

clean:
	make -f $(MAKEFILE_DOCBOOK) clean
	$(RM) *.xml
