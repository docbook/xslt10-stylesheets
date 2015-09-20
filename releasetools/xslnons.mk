# this file is a -*- makefile -*- snippet
# targets in this file are used to build and upload the namespaced
# version of the DocBook Project XSL Stylesheets

# $Id$

freshmeat-nons:
ifeq ($(SFRELID),)
	@echo "You must specify the sourceforge release identifier in SFRELID"
	exit 1
else
	$(XSLT) $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/VERSION $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/VERSION \
	  $(TMP)/fm-docbook-$(DISTRO)-nons sf-relid=$(SFRELID)
	grep -v "<?xml" $(TMP)/fm-docbook-$(DISTRO)-nons | $(FRESHMEAT_SUBMIT) $(FMGO)
endif

zip-nons: zip
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	rm -rf $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)
	$(RM)  $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER).tar.gz
	$(RM)  $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER).tar.bz2
	$(RM)  $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER).zip
	(cd $(TMP) && \
	  unzip $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip && \
	  $(DOCBOOK_SVN)/releasetools/xslnons-build \
	  docbook-$(DISTRO)-$(ZIPVER) \
	  docbook-$(DISTRO)-nons-$(ZIPVER)); 


# Run xslt on xsl/webhelp/docsrc/readme.xml
	$(XSLT) \
	$(TMP)/docbook-$(DISTRO)-$(ZIPVER)/webhelp/docsrc/readme.xml \
	$(DOCBOOK_SVN)/docbook/relaxng/tools/db4-upgrade.xsl \
	$(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/webhelp/docsrc/readme.xml 
	$(XSLT) \
	$(TMP)/docbook-$(DISTRO)-$(ZIPVER)/webhelp/docsrc/xinclude-test.xml \
	$(DOCBOOK_SVN)/docbook/relaxng/tools/db4-upgrade.xsl \
	$(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/webhelp/docsrc/xinclude-test.xml 

# Turn off validation in webhelp:
	sed -i"" "s/validate-against-dtd=true/validate-against-dtd=false/" \
	  $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/webhelp/build.properties

# change branch info
	sed -i"" "s/^\(.*\)<fm:Branch>XSL Stylesheets<\/fm:Branch>$$/\1<fm:Branch>XSL-NS Stylesheets<\/fm:Branch>/" \
	  $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/VERSION

# change distro name









	sed -i"" "s/^\(.*\)<xsl:param name=\"DistroName\">docbook-xsl<\/xsl:param>$$/\1<xsl:param name=\"DistroName\">docbook-xsl-nons<\/xsl:param>/" \
	  $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/VERSION

# fix catalog.xml file
	$(XSLT) .make-catalog.xsl .make-catalog.xsl \
	  DISTRO="$(DISTRO)-nons" BRANCH="XSL-NONS" \
	  | $(XMLLINT) $(XMLLINT_OPTS) --format --encode utf-8 - \
	  > $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/catalog.xml

# repair perms
	chmod 755 $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/fo/pdf2index
	chmod 755 $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/install.sh
	chmod 755 $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER)/tools/bin/docbook-xsl-update

# gzip/bzip/zip it
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-nons-$(ZIPVER) \
	| gzip >  docbook-$(DISTRO)-nons-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-nons-$(ZIPVER) \
	| bzip2 > docbook-$(DISTRO)-nons-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && $(ZIP) $(ZIPFLAGS) docbook-$(DISTRO)-nons-$(ZIPVER).zip \
	 docbook-$(DISTRO)-nons-$(ZIPVER)

upload-to-project-webspace-nons: zip-nons
ifeq ($(SF_USERNAME),)
	$(error You must specify a value for $$SF_USERNAME)
else
	-$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	-$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	-$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-nons-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)-nons/
	-$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-nons-slides-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)-nons/
	-$(SSH) $(SSH_OPTS)-l $(SF_USERNAME) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   cd $(RELEASE_DIR)/$(DISTRO)-nons; \
	   rm -rf $(ZIPVER); \
	   cp -p ../$(DISTRO)/docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2 .; \
	   $(TAR) xfj$(TARFLAGS) docbook-$(DISTRO)-nons-$(ZIPVER).tar.bz2; \
	   $(TAR) xfj$(TARFLAGS) docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2; \
	   mv docbook-$(DISTRO)-nons-$(ZIPVER) $(ZIPVER); \
	   mv docbook-$(DISTRO)-$(ZIPVER)/doc $(ZIPVER); \
	   rm -rf docbook-$(DISTRO)-$(ZIPVER); \
	   gunzip $(ZIPVER)/doc/reference.pdf.gz; \
	   gunzip $(ZIPVER)/doc/reference.txt.gz; \
	   chmod -R g+w $(ZIPVER); \
	   $(RM) current; \
	   ln -s $(ZIPVER) current; \
	   rm -f docbook-$(DISTRO)-nons-$(ZIPVER).tar.bz2; \
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

install-nons: install upload-to-project-webspace-nons
	@echo "The docbook-$(DISTRO), docbook-$(DISTRO)-nons, docbook-$(DISTRO)-nons packages have been uploaded to"
	@echo "the SF incoming area."
	@echo "Use the following form to move the uploaded files to the project release area."
	@echo
	@echo "  http://sourceforge.net/project/admin/editpackages.php?group_id=21935"

announce-nons: announce
	$(RELEASE_ANNOUNCE) "XSL-NS Stylesheets" "$(RELVER)" \
	  $(DOCBOOK_SVN)/releasetools/xslnsfiles/announcement-text \
	  $(ANNOUNCE_CHANGES) \
	 "$(ANNOUNCE_RECIPIENTS)"
