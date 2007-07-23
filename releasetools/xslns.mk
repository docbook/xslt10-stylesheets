# this file is a -*- makefile -*- snippet
# targets in this file are used to build and upload the namespaced
# version of the DocBook Project XSL Stylesheets

# $Id$

freshmeat-ns:
ifeq ($(SFRELID),)
	@echo "You must specify the sourceforge release identifier in SFRELID"
	exit 1
else
	$(XSLT) $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/VERSION $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/VERSION \
	  $(TMP)/fm-docbook-$(DISTRO)-ns sf-relid=$(SFRELID)
	grep -v "<?xml" $(TMP)/fm-docbook-$(DISTRO)-ns | $(FRESHMEAT_SUBMIT) $(FMGO)
endif

zip-ns: zip
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	rm -rf $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)
	$(RM)  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).tar.gz
	$(RM)  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).tar.bz2
	$(RM)  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).zip
	(cd $(TMP) && \
	  unzip $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip && \
	  $(DOCBOOK_SVN)/releasetools/xslns-build \
	  docbook-$(DISTRO)-$(ZIPVER) \
	  docbook-$(DISTRO)-ns-$(ZIPVER)); 

# change branch info
	sed -i "s/^\(.*\)<fm:Branch>XSL Stylesheets<\/fm:Branch>$$/\1<fm:Branch>XSL-NS Stylesheets<\/fm:Branch>/" \
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

upload-to-project-webspace-ns: zip-ns
ifeq ($(SF_USERNAME),)
	$(error You must specify a value for $$SF_USERNAME)
else
	-$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	-$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	-$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)-ns/
	-$(SSH) $(SSH_OPTS)-l $(SF_USERNAME) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   cd $(RELEASE_DIR)/$(DISTRO)-ns; \
	   rm -rf $(ZIPVER); \
	   cp -p ../$(DISTRO)/docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2 .; \
	   $(TAR) xfj$(TARFLAGS) docbook-$(DISTRO)-ns-$(ZIPVER).tar.bz2; \
	   $(TAR) xfj$(TARFLAGS) docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2; \
	   mv docbook-$(DISTRO)-ns-$(ZIPVER) $(ZIPVER); \
	   mv docbook-$(DISTRO)-$(ZIPVER)/doc $(ZIPVER); \
	   rm -rf docbook-$(DISTRO)-$(ZIPVER); \
	   gunzip $(ZIPVER)/doc/reference.pdf.gz; \
	   gunzip $(ZIPVER)/doc/reference.txt.gz; \
	   chmod -R g+w $(ZIPVER); \
	   $(RM) current; \
	   ln -s $(ZIPVER) current; \
	   rm -f docbook-$(DISTRO)-ns-$(ZIPVER).tar.bz2; \
	   rm -f docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2; \
	   cd $(RELEASE_DIR)/$(DISTRO); \
	   rm -rf $(ZIPVER); \
	   $(TAR) xfj$(TARFLAGS) docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   $(TAR) xfj$(TARFLAGS) docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2; \
	   mv docbook-$(DISTRO)-$(ZIPVER) $(ZIPVER); \
	   gunzip $(ZIPVER)/doc/reference.pdf.gz; \
	   gunzip $(ZIPVER)/doc/reference.txt.gz; \
	   chmod -R g+w $(ZIPVER); \
	   $(RM) current; \
	   ln -s $(ZIPVER) current; \
	   rm -f docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   rm -f docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2; \
	   )"
endif

install-ns: upload-to-sf-incoming upload-to-project-webspace-ns
	@echo "The docbook-$(DISTRO), docbook-$(DISTRO)-ns, docbook-$(DISTRO)-ns packages have been uploaded to"
	@echo "the SF incoming area."
	@echo "Use the following form to move the uploaded files to the project release area."
	@echo
	@echo "  http://sourceforge.net/project/admin/editpackages.php?group_id=21935"
