# this file is a -*- makefile -*- snippet
# targets in the file are used only for release builds

debug:

.PHONY: ChangeLog.xml ChangeHistory.xml

RELEASE-NOTES.html: RELEASE-NOTES.xml NEWS.xml
	$(XINCLUDE) $< > RELEASE-NOTES-TMP.xml
	$(XSLT) RELEASE-NOTES-TMP.xml $(DOC_LINK_STYLE) $@ \
	doc-baseuri="$(DOC_BASEURI)" \
	profile.condition="$(RELEASE_TYPE)"
	$(RM) RELEASE-NOTES-TMP.xml

RELEASE-NOTES.txt: RELEASE-NOTES.html
	$(BROWSER) $(BROWSER_OPTS) $< > $@

RELEASE-NOTES-PARTIAL.html: RELEASE-NOTES.xml NEWS.xml
	$(XINCLUDE) $< > RELEASE-NOTES-PARTIAL-TMP.xml
	$(XSLT) RELEASE-NOTES-PARTIAL-TMP.xml $(DOC_LINK_STYLE) $@ \
	doc-baseuri="$(DOC_BASEURI)" \
	rootid="current"
	$(RM) RELEASE-NOTES-PARTIAL-TMP.xml

RELEASE-NOTES-PARTIAL.txt: RELEASE-NOTES-PARTIAL.html
	$(BROWSER) $(BROWSER_OPTS) $< > $@
	$(RM) $<

RELEASE-NOTES.pdf: RELEASE-NOTES.xml NEWS.xml
	$(XINCLUDE) $< > RELEASE-NOTES-TMP.xml
ifeq ($(PDF_MAKER),xep)
	$(XSLT) RELEASE-NOTES-TMP.xml $(FO_STYLE) $(basename $<).fo $(PDF_MAKER).extensions=1 \
	profile.condition="$(RELEASE_TYPE)" \
	&& $(XEP) $(XEP_FLAGS) $(basename $<).fo
	$(RM) RELEASE-NOTES-TMP.xml
else
ifeq ($(PDF_MAKER),dblatex)
	$(XSLT) RELEASE-NOTES-TMP.xml $(STRIP_NS) RELEASE-NOTES-STRIPPED-TMP.xml \
	&& $(DBLATEX) $(DBLATEX_FLAGS) \
	  -p $(DBX_STYLE) \
	  -o $@ \
	  RELEASE-NOTES-STRIPPED-TMP.xml 2>&1 | $(TAIL)
	$(RM) RELEASE-NOTES-STRIPPED-TMP.xml
	$(RM) RELEASE-NOTES-TMP.xml
endif
endif

$(MARKUP_XSL):
	$(MAKE) -C $(dir $(MARKUP_XSL))

NEWS.xml: ChangeLog.xml
	$(XSLT) $< $(GITLOG2DOCBOOK) $@ \
	previous-release="$(PREVIOUS_RELEASE)" \
	release-version="$(RELVER)" \
	element.file="$(DOCBOOK_ELEMENTS)" \
	param.file="$(XSL_PARAMS)"

	mv NEWS.xml NEWS-4.xml
	$(XSLT) NEWS-4.xml $(repo_dir)/xsl/tools/xsl/build/db4-upgrade.xsl $@
	rm NEWS-4.xml

NEWS.html: NEWS.xml
	$(XSLT) $< $(DOC_LINK_STYLE) $@ \
	doc-baseuri="$(DOC_BASEURI)"

$(NEWSFILE): NEWS.html
	$(BROWSER) $(BROWSER_OPTS) $< > $@

ChangeLog.xml:
	python $(repo_dir)/releasetools/changelog.py > $@

ChangeHistory.xml.zip: ChangeHistory.xml
	$(ZIP) $(ZIP_OPTS) $@ $<
	$(RM) $<

# ChangeHistory.xml holds the whole change history for the module,
# including all subdirectories
ChangeHistory.xml:
	python $(repo_dir)/releasetools/changelog.py all > $@

.CatalogManager.properties.example:
	cp -p $(CATALOGMANAGER) .CatalogManager.properties.example

.urilist:
	for uri in $(URILIST); do \
	echo $$uri >> .urilist; \
	done

.make-catalog.xsl: $(MAKECATALOG)
	cp $< $@

catalog.xml: .make-catalog.xsl
	$(XSLT) $< $< DISTRO="$(DISTRO)" \
	  | $(XMLLINT) $(XMLLINT_OPTS) --format --encode utf-8 --output $@ -

install.sh: $(INSTALL_SH) .CatalogManager.properties.example .urilist catalog.xml
	cp $< $@

ifeq ($(OFFLINE),yes)
distrib: all $(DISTRIB_DEPENDS)
else
distrib: all $(DISTRIB_DEPENDS) $(NEWSFILE)
endif

release: distrib $(RELEASE_DEPENDS)

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
# if we find a Makefile.tests file, rename it to Makefile, and
# update the tar.exclude contents so that it doesn't get excluded
	if [ -f Makefile.tests ]; then \
	  cp -p Makefile.tests $(TMP)/docbook-$(DISTRO)-$(ZIPVER)/Makefile; \
	  sed -i -r 's/^Makefile\$$$$//' $(TMP)/tar.exclude; \
	fi
# tar up distro, then gzip/bzip/zip it
	-$(TAR) cf$(TARFLAGS) - -X $(TMP)/tar.exclude * .[^.]* | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); $(TAR) xf$(TARFLAGS) -)
	umask 022; cd $(TMP) && $(ZIP) $(ZIPFLAGS) docbook-$(DISTRO)-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)
	$(RM) $(TMP)/tar.exclude

# -----------------------------------------------------------------
#     Prepare *zip files for other parts of distro (if any)
# -----------------------------------------------------------------
ifneq ($(DISTRIB_PACKAGES),)
	for part in $(DISTRIB_PACKAGES); do \
          dirname=docbook-$(DISTRO)-$(ZIPVER); \
          package_name=docbook-$(DISTRO)-$$part-$(ZIPVER); \
          if [ "$$part" = slides ]; then \
            dirname=docbook-$(DISTRO)-ns-$(ZIPVER); \
            package_name=docbook-$(DISTRO)-ns-slides-$(ZIPVER); \
          fi; \
	  rm -rf $(TMP)/$$dirname; \
	  $(RM)  $(TMP)/tar.exclude; \
	  $(RM)  $(TMP)/$$package_name.zip; \
	  umask 022; mkdir -p $(TMP)/$$dirname; \
	  touch $(TMP)/tar.exclude; \
	  if [ -n "$(DISTRIB_EXCLUDES)" ]; then \
	    for file in $(DISTRIB_EXCLUDES); do \
	      find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	    done; \
	  fi; \
	  for file in $(ZIP_EXCLUDES); do \
	    find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	  done; \
	  $(TAR) cf$(TARFLAGS) - -X $(TMP)/tar.exclude --ignore-failed-read $$part images | (cd $(TMP)/$$dirname; $(TAR) xf$(TARFLAGS) -); \
	  umask 022; (cd $(TMP) && \
	  if [ -d $$dirname/images ]; \
	    then mv $$dirname/images $$dirname/doc/; \
	  fi) ; \
	  umask 022; (cd $(TMP) && $(ZIP) $(ZIPFLAGS) $$package_name.zip $$dirname); \
	  $(RM) $(TMP)/tar.exclude; \
	done
endif
endif

install: $(INSTALL_DEPENDS)

announce: $(ANNOUNCE_CHANGES) .announcement-text
	$(RELEASE_ANNOUNCE) "$(DISTRO_TITLE)" "$(RELVER)" .announcement-text $< "$(ANNOUNCE_RECIPIENTS)"

release-clean: clean $(RELEASE_CLEAN_TARGETS)
	$(RM) TERMS.xml
	$(RM) $(NEWSFILE)
	$(RM) NEWS.html
	$(RM) NEWS.xml
	$(RM) RELEASE-NOTES-TMP.xml
	$(RM) ChangeHistory.xml
	$(RM) ChangeHistory.xml.zip
	$(RM) ChangeLog.xml 
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
