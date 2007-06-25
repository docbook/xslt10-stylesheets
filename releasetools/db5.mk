# this file is a -*- makefile -*- snippet
# targets in this file are used to build and upload the namespaced
# version of the DocBook Project XSL Stylesheets

# $Id$

debug:

freshmeat-ns:
ifeq ($(SFRELID),)
	@echo "You must specify the sourceforge release identifier in SFRELID"
	exit 1
else
	$(XSLT) VERSION VERSION $(TMP)/fm-docbook-$(DISTRO)-ns sf-relid=$(SFRELID)
	grep -v "<?xml" $(TMP)/fm-docbook-$(DISTRO)-ns | freshmeat-submit $(FMGO)
endif

zip-ns: zip
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	rm -rf $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)
	$(RM)  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).tar.gz
	$(RM)  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).tar.bz2
	$(RM)  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).zip
	(cd $(TMP) && \
	  unzip $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip && \
	  $(DOCBOOK_SVN)/releasetools/makexslns \
	  docbook-$(DISTRO)-$(ZIPVER) \
	  docbook-$(DISTRO)-ns--$(ZIPVER)); 

# change branch info
	sed -i "s/^\(.*\)<fm:Branch>XSL Stylesheets<\/fm:Branch>$$/\1<fm:Branch>XSL NS Stylesheets<\/fm:Branch>/" \
	  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/VERSION

# change distro name
	sed -i "s/^\(.*\)<xsl:param name=\"DistroName\">docbook-xsl<\/xsl:param>$$/\1<xsl:param name=\"DistroName\">docbook-xsl-ns<\/xsl:param>/" \
	  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/VERSION

# repair perms
	chmod 755 $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/fo/pdf2index
	chmod 755 $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/install.sh

# gzip/bzip/zip it
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-ns-$(ZIPVER) \
	| gzip >  docbook-$(DISTRO)-ns-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-ns-$(ZIPVER) \
	| bzip2 > docbook-$(DISTRO)-ns-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && $(ZIP) $(ZIPFLAGS) docbook-$(DISTRO)-ns-$(ZIPVER).zip \
	 docbook-$(DISTRO)-ns-$(ZIPVER)

install-ns: zip-ns install
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
