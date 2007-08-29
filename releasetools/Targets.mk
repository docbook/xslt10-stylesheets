# this file is a -*- makefile -*- snippet
# targets in the file are used only for release builds

# $Id$

debug:

.PHONY: ChangeLog.xml ChangeHistory.xml $(SVN_INFO_FILE)

RELEASE-NOTES.html: RELEASE-NOTES.xml NEWS.xml
	$(XINCLUDE) $< > RELEASE-NOTES-TMP.xml
	$(XSLT) RELEASE-NOTES-TMP.xml $(DOC_LINK_STYLE) $@ \
	doc-baseuri="http://docbook.sourceforge.net/release/xsl/current/doc/"
	$(RM) RELEASE-NOTES-TMP.xml

RELEASE-NOTES.txt: RELEASE-NOTES.html
	LANG=C $(BROWSER) $(BROWSER_OPTS) $< > $@

RELEASE-NOTES-PARTIAL.html: RELEASE-NOTES.xml NEWS.xml
	$(XINCLUDE) $< > RELEASE-NOTES-PARTIAL-TMP.xml
	$(XSLT) RELEASE-NOTES-PARTIAL-TMP.xml $(DOC_LINK_STYLE) $@ \
	doc-baseuri="http://docbook.sourceforge.net/release/xsl/current/doc/" \
	rootid="V$(RELVER)"
	$(RM) RELEASE-NOTES-PARTIAL-TMP.xml

RELEASE-NOTES-PARTIAL.txt: RELEASE-NOTES-PARTIAL.html
	LANG=C $(BROWSER) $(BROWSER_OPTS) $< > $@
	$(RM) $<

RELEASE-NOTES.pdf: RELEASE-NOTES.xml NEWS.xml
	$(XINCLUDE) $< > RELEASE-NOTES-TMP.xml
ifeq ($(PDF_MAKER),xep)
	$(XSLT) RELEASE-NOTES-TMP.xml $(FO_STYLE) $(basename $<).fo $(PDF_MAKER).extensions=1 \
	&& $(XEP) $(XEP_FLAGS) $(basename $<).fo
	$(RM) RELEASE-NOTES-TMP.xml
else
ifeq ($(PDF_MAKER),dblatex)
	$(XSLT) RELEASE-NOTES-TMP.xml $(STRIP_NS) RELEASE-NOTES-STRIPPED-TMP.xml
	-$(DBLATEX) $(DBLATEX_FLAGS) \
	  -p $(DBX_STYLE) \
	  -o $@ \
	  RELEASE-NOTES-STRIPPED-TMP.xml
	$(RM) RELEASE-NOTES-STRIPPED-TMP.xml
	$(RM) RELEASE-NOTES-TMP.xml
endif
endif

$(MARKUP_XSL):
	$(MAKE) -C $(dir $(MARKUP_XSL))

NEWS.xml: ChangeLog.xml
	$(XSLT) $< $(SVNLOG2DOCBOOK) $@ \
	repositoryRoot="$(REPOSITORY_ROOT)" \
	distroParentUrl="$(DISTRO_PARENT_URL)" \
	distro="$(DISTRO)" \
	previous-release="$(PREVIOUS_RELEASE)" \
	release-version="$(RELVER)" \
	element.file="$(shell readlink -f $(DOCBOOK_ELEMENTS))" \
	param.file="$(shell readlink -f $(XSL_PARAMS))"

NEWS.html: NEWS.xml
	$(XSLT) $< $(DOC_LINK_STYLE) $@

$(NEWSFILE): NEWS.html
	LANG=C $(BROWSER) $(BROWSER_OPTS) $< > $@

$(SVN_INFO_FILE):
	$(SVN) $(SVN_OPTS) info --xml \
	| $(XMLLINT) $(XMLLINT_OPTS) --format - > $@

ChangeLog.xml: $(SVN_INFO_FILE)
	$(SVN) $(SVN_OPTS) log --xml --verbose \
	-r HEAD:$(PREVIOUS_REVISION) \
	$(DISTRO_PARENT_URL) \
	$(DISTRO) $(DISTRIB_CHANGELOG_INCLUDES) \
	| $(XMLLINT) $(XMLLINT_OPTS) --format - > $@

ChangeHistory.xml.zip: ChangeHistory.xml
	$(ZIP) $(ZIP_OPTS) $@ $<
	$(RM) $<

# ChangeHistory.xml holds the whole change history for the module,
# including all subdirectories
ChangeHistory.xml:
	$(SVN) $(SVN_OPTS) log --xml --verbose > $@

.CatalogManager.properties.example:
	cp -p $(CATALOGMANAGER) .CatalogManager.properties.example

.urilist:
	for uri in $(URILIST); do \
	echo $$uri >> .urilist; \
	done

.make-catalog.xsl: $(MAKECATALOG)
	cp $< $@

catalog.xml: .make-catalog.xsl
	$(XSLT) $< $< $@ DISTRO="$(DISTRO)"

install.sh: $(INSTALL_SH) .CatalogManager.properties.example .urilist catalog.xml
	cp $< $@

ifeq ($(OFFLINE),yes)
distrib: all $(DISTRIB_DEPENDS)
else
distrib: all $(DISTRIB_DEPENDS) $(NEWSFILE)
endif

release: distrib $(RELEASE_DEPENDS)

freshmeat:
ifeq ($(SFRELID),)
	@echo "You must specify the sourceforge release identifier in SFRELID"
	exit 1
else
	$(XSLT) VERSION VERSION $(TMP)/fm-docbook-$(DISTRO) sf-relid=$(SFRELID)
	grep -v "<?xml" $(TMP)/fm-docbook-$(DISTRO) | $(FRESHMEAT_SUBMIT) $(FMGO)
endif

zip: $(ZIP_DEPENDS)
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
	exit 1
else

# -----------------------------------------------------------------
#          Prepare *zip files for main part of distro
# -----------------------------------------------------------------
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	$(RM)  $(TMP)/tar.exclude
	$(RM)  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.gz
	$(RM)  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	$(RM)  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip
	umask 022; mkdir -p $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	touch $(TMP)/tar.exclude
# distro-specific excludes
ifneq ($(DISTRIB_EXCLUDES),)
	for file in $(DISTRIB_EXCLUDES); do \
	  find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	done
endif
# global excludes
	for file in $(ZIP_EXCLUDES); do \
	  find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	done
# excludes for distros that end up as multiple packages
ifneq ($(DISTRIB_PACKAGES),)
	for part in $(DISTRIB_PACKAGES); do \
	  find . -print  | grep "^./$$part/" | cut -c3- >> $(TMP)/tar.exclude; \
	done
endif
# tar up distro, then gzip/bzip/zip it
	$(TAR) cf$(TARFLAGS) - -X $(TMP)/tar.exclude * .[^.]* | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); $(TAR) xf$(TARFLAGS) -)
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && $(ZIP) $(ZIPFLAGS) docbook-$(DISTRO)-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)
	$(RM) $(TMP)/tar.exclude

# -----------------------------------------------------------------
#     Prepare *zip files for other parts of distro (if any)
# -----------------------------------------------------------------
ifneq ($(DISTRIB_PACKAGES),)
	for part in $(DISTRIB_PACKAGES); do \
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER); \
	$(RM)  $(TMP)/tar.exclude; \
	$(RM)  $(TMP)/docbook-$(DISTRO)-$$part-$(ZIPVER).tar.gz; \
	$(RM)  $(TMP)/docbook-$(DISTRO)-$$part-$(ZIPVER).tar.bz2; \
	$(RM)  $(TMP)/docbook-$(DISTRO)-$$part-$(ZIPVER).zip; \
	umask 022; mkdir -p $(TMP)/docbook-$(DISTRO)-$(ZIPVER); \
	touch $(TMP)/tar.exclude; \
	if [ -n "$(DISTRIB_EXCLUDES)" ]; then \
	for file in $(DISTRIB_EXCLUDES); do \
	  find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	done; \
	fi; \
	for file in $(ZIP_EXCLUDES); do \
	  find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	done; \
	$(TAR) cf$(TARFLAGS) - -X $(TMP)/tar.exclude --ignore-failed-read $$part images | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); $(TAR) xf$(TARFLAGS) -); \
	umask 022; (cd $(TMP) && \
	if [ -d docbook-$(DISTRO)-$(ZIPVER)/images ]; \
	  then mv docbook-$(DISTRO)-$(ZIPVER)/images docbook-$(DISTRO)-$(ZIPVER)/doc/; \
	fi) ; \
	umask 022; (cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-$$part-$(ZIPVER).tar.gz); \
	umask 022; (cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-$$part-$(ZIPVER).tar.bz2); \
	umask 022; (cd $(TMP) && $(ZIP) $(ZIPFLAGS) docbook-$(DISTRO)-$$part-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)); \
	$(RM) $(TMP)/tar.exclude; \
	done
endif
endif

upload-to-sf-incoming: zip
ifeq ($(SF_USERNAME),)
	$(error You must specify a value for $$SF_USERNAME)
else
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-$(DISTRO)-*-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST) && \
	$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
endif

upload-to-project-webspace: zip
ifeq ($(SF_USERNAME),)
	$(error You must specify a value for $$SF_USERNAME)
else
	-$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	-$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2 $(SF_USERNAME)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	-$(SSH) $(SSH_OPTS)-l $(SF_USERNAME) $(PROJECT_HOST) \
	  "(\
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

install: tag upload-to-sf-incoming upload-to-project-webspace
	@echo "The docbook-$(DISTRO) and docbook-$(DISTRO)-doc packages have been uploaded to the SF incoming area."
	@echo "Use the form at the following URL to move files to the project release area."
	@echo
	@echo "  http://sourceforge.net/project/admin/editpackages.php?group_id=21935"

announce: $(ANNOUNCE_CHANGES) .announcement-text distrib
	$(RELEASE_ANNOUNCE) "$(DISTRO_TITLE)" "$(RELVER)" .announcement-text $< "$(ANNOUNCE_RECIPIENTS)"

tag:
ifeq (,$(shell svn status))
ifneq (,$(shell svn info $(REPOSITORY_ROOT)/tags/$(TAG)/$(DISTRO) 2>/dev/null))
	  $(SVN) $(SVN_OPTS) delete -m "deleting the $(DISTRO) $(ZIPVER) tag" \
	    $(REPOSITORY_ROOT)/tags/$(TAG)/$(DISTRO)
endif
ifeq (,$(shell svn info $(REPOSITORY_ROOT)/tags/$(TAG) 2>/dev/null))
	  $(SVN) $(SVN_OPTS) mkdir -m "creating the $(ZIPVER) tag" \
	    $(REPOSITORY_ROOT)/tags/$(TAG)
endif
	  $(SVN) $(SVN_OPTS) copy -m "tagging the $(DISTRO) $(ZIPVER) release" \
	    -r $(REVISION) $(DISTRO_URL) $(REPOSITORY_ROOT)/tags/$(TAG)/$(DISTRO)
else
	  @echo "Unversioned or uncommitted files found. Before tagging/uploading"
	  @echo "the release, either delete the following files, add them to the"
	  @echo "repository, or add them to the svn:ignore properties for their"
	  @echo "parent directories."
	  @echo
	  @svn status
endif

release-clean: clean
	$(MAKE) -C docsrc release-clean
	$(RM) TERMS.xml
	$(RM) $(NEWSFILE)
	$(RM) NEWS.html
	$(RM) NEWS.xml
	$(RM) RELEASE-NOTES-TMP.xml
	$(RM) ChangeHistory.xml
	$(RM) ChangeHistory.xml.zip
	$(RM) ChangeLog.xml 
	$(RM) $(SVN_INFO_FILE)
	$(RM) RELEASE-NOTES.txt
	$(RM) RELEASE-NOTES.html
	$(RM) RELEASE-NOTES.fo
	$(RM) RELEASE-NOTES.pdf
	$(RM) RELEASE-NOTES.FULL.xml
	$(RM) install.sh
	$(RM) test.sh
	$(RM) uninstall.sh
	$(RM) .CatalogManager.properties.example
	$(RM) .cshrc.incl
	$(RM) .profile.incl
	$(RM) .emacs.el
	$(RM) .urilist
	$(RM) .make-catalog.xsl
	$(RM) catalog.xml
