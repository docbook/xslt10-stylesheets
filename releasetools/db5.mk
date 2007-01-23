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
	(cd $(TMP); \
	  unzip $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip)
	$(DOCBOOK_SVN)/releasetools/makedb5xsl \
	 $(TMP)/docbook-$(DISTRO)-$(ZIPVER) \
	 $(TMP)/docbook5-$(DISTRO)-$(ZIPVER)

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
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - $(TMP)/docbook5-$(DISTRO)-$(ZIPVER) \
	| gzip > $(TMP)/docbook5-$(DISTRO)-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - $(TMP)/docbook5-$(DISTRO)-$(ZIPVER) \
	| bzip2 > docbook5-$(DISTRO)-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && $(ZIP) $(ZIPFLAGS) $(TMP)/docbook5-$(DISTRO)-$(ZIPVER).zip \
	$(TMP)/docbook5-$(DISTRO)-$(ZIPVER)

install5: zip5 install
ifeq ($(SF_USERNAME),)
	$(error You must specify a value for $$SF_USERNAME)
else
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook5-$(DISTRO)-*-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook5-$(DISTRO)-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
	$(SCP) $(SCP_OPTS) $(TMP)/docbook5-$(DISTRO)-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	$(SCP) $(SCP_OPTS) $(TMP)/docbook5-$(DISTRO)-*-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	$(SSH) $(SSH_OPTS)-l $(SF_USERNAME) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   cd $(RELEASE_DIR)/$(DISTRO); \
	   rm -rf $(ZIPVER); \
	   $(TAR) xfj$(TARFLAGS) docbook5-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   $(TAR) xfj$(TARFLAGS) docbook5-$(DISTRO)-*-$(ZIPVER).tar.bz2; \
	   mv docbook-$(DISTRO)-$(ZIPVER) $(ZIPVER); \
	   gunzip $(ZIPVER)/doc/reference.pdf.gz; \
	   gunzip $(ZIPVER)/doc/reference.txt.gz; \
	   rm -rf docbook5-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   rm -rf docbook5-$(DISTRO)-*-$(ZIPVER).tar.bz2; \
	   chmod -R g+w $(ZIPVER); \
	   $(RM) current; \
	   ln -s $(ZIPVER) current; \
	   )"
endif
