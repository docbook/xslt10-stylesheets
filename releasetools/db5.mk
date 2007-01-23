# this file is a -*- makefile -*- snippet
# targets in this file are used to build and upload the DocBook 5
# version of the DocBook Project XSL Stylesheets

# $Id$

debug:

freshmeat5:
ifeq ($(SFRELID),)
	@echo "You must specify the sourceforge release identifier in SFRELID"
	exit 1
else
	$(XSLT) VERSION VERSION $(TMP)/fm-docbook5-$(DISTRO) sf-relid=$(SFRELID)
	grep -v "<?xml" $(TMP)/fm-docbook5-$(DISTRO) | freshmeat-submit $(FMGO)
endif

zip5: zip
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	rm -rf $(TMP)/docbook5-$(DISTRO)-$(ZIPVER)
	$(RM)  $(TMP)/docbook5-$(DISTRO)-$(ZIPVER).tar.gz
	$(RM)  $(TMP)/docbook5-$(DISTRO)-$(ZIPVER).tar.bz2
	$(RM)  $(TMP)/docbook5-$(DISTRO)-$(ZIPVER).zip
	(cd $(TMP) && \
	  unzip $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip && \
	  $(DOCBOOK_SVN)/releasetools/makedb5xsl \
	  docbook-$(DISTRO)-$(ZIPVER) \
	  docbook5-$(DISTRO)-$(ZIPVER)); 

# change branch info
	sed -i "s/^\(.*\)<fm:Branch>XSL Stylesheets<\/fm:Branch>$$/\1<fm:Branch>v5 XSL Stylesheets<\/fm:Branch>/" \
	  $(TMP)/docbook5-$(DISTRO)-$(ZIPVER)/VERSION

# change distro name
	sed -i "s/^\(.*\)<xsl:param name=\"DistroName\">docbook-xsl<\/xsl:param>$$/\1<xsl:param name=\"DistroName\">docbook5-xsl<\/xsl:param>/" \
	  $(TMP)/docbook5-$(DISTRO)-$(ZIPVER)/VERSION

# repair perms
	chmod 755 $(TMP)/docbook5-$(DISTRO)-$(ZIPVER)/fo/pdf2index
	chmod 755 $(TMP)/docbook5-$(DISTRO)-$(ZIPVER)/install.sh

# gzip/bzip/zip it
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook5-$(DISTRO)-$(ZIPVER) \
	| gzip >  docbook5-$(DISTRO)-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook5-$(DISTRO)-$(ZIPVER) \
	| bzip2 > docbook5-$(DISTRO)-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && $(ZIP) $(ZIPFLAGS) docbook5-$(DISTRO)-$(ZIPVER).zip \
	 docbook5-$(DISTRO)-$(ZIPVER)

install5: zip5 install
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook5-$(DISTRO)-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
