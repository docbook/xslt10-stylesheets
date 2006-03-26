# this file is a -*- makefile -*- snippet
# targets in the file are used only for release builds

# $Id$

debug:

ifeq ($(TAGVER),$(shell if [ -f LatestTag ]; then cat LatestTag; fi))
RELEASE-NOTES.html: RELEASE-NOTES.xml
else
RELEASE-NOTES.html: RELEASE-NOTES-$(TAGVER).xml
endif
	$(XSLT) $< $(DOC-LINK-STYLE) $@

RELEASE-NOTES.txt: RELEASE-NOTES.html
	LANG=C $(BROWSER) $(BROWSER_OPTS) $< > $@

ifeq ($(TAGVER),$(shell if [ -f LatestTag ]; then cat LatestTag; fi))
RELEASE-NOTES.pdf: RELEASE-NOTES.xml
else
RELEASE-NOTES.pdf: RELEASE-NOTES-$(TAGVER).xml
endif
	$(XSLT) $< $(FO-STYLE) $(basename $<).fo $(FO_ENGINE).extensions=1 \
	&& $(FO_ENGINE) $(FO_ENGINE_OPTS) $(basename $<).fo

RELEASE-NOTES-$(TAGVER).xml: RELEASE-NOTES.xml NEWS.xml
	$(XINCLUDE) $< > $@

NEWS.xml: ChangeLog.xml
	$(XSLT) $< $(NEWS_MAKER) $@ \
	latest-tag="'$(shell cat LatestTag)'" \
	release-version="'$(RELVER)'"
	for element in \
	  $(shell $(XSLT) $(DOCBOOK_RNG) $(GET_ELEMENT_NAMES) | sort | uniq); \
	do $(SED) $(SED_OPTS) -i \
	  "s/\([^<\/A-Za-z0-9_\.\-]\)\($$element\)\([^A-Za-z0-9_\.\-]\)/\1<FOOM>\2<\/FOOM>\3/g" $@; done; \
	$(SED) $(SED_OPTS) -i s/FOOM/tag/g $@

NEWS.html: NEWS.xml
	$(XSLT) $< $(DOC-LINK-STYLE) $@

$(NEWSFILE): NEWS.html
	LANG=C $(BROWSER) $(BROWSER_OPTS) $< > $@

ChangeLog.xml: LatestTag
	$(CVS2CL) $(CVS2CL_OPTS) \
	--delta $(shell cat LatestTag):HEAD --xml -f $@ -g -q

LatestTag:
# Note that one of the old commit messsage in the cvs log contains
# a ^Z (x1a) character, which is not legal in XML, so it must
# strip it out before using it with any XML processing apps
	$(CVS2CL) $(CVS2CL_OPTS) --stdout --xml -g -q \
	| $(SED) $(SED_OPTS) 's/\x1a//g' \
	| $(XSLTPROC) $(GET_LATEST_TAG) - > $@

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

install.sh: .CatalogManager.properties.example .urilist catalog.xml
	cp $(INSTALL_SH) install.sh

distrib: all $(DISTRIB_DEPENDS) RELEASE-NOTES.txt RELEASE-NOTES.pdf $(NEWSFILE)

newversion:
ifeq ($(CVSCHECK),)
ifeq ($(DIFFVER),)
	@echo "DIFFVER must be specified."
	exit 1
else
ifeq ($(NEXTVER),$(RELVER))
	read -s -n1 -p "OK to create cvs tag $(TAGVER)? [No] "; \
	    echo "$$REPLY"; \
	    case $$REPLY in \
	      [yY]) \
	      cvs tag $(TAGVER); \
	      $(MAKE) DIFFVER=$(DIFFVER) distrib; \
	      ;; \
	      *) echo "OK, exiting without making creating tag."; \
	      exit \
	      ;; \
	    esac
else
	@echo "VERSION $(RELVER) doesn't match specified version $(NEXTVER)."
	exit 1
endif
endif
else
	@echo "CVS is not up-to-date! ($(CVSCHECK))"
	exit 1
endif

freshmeat:
ifeq ($(SFRELID),)
	@echo "You must specify the sourceforge release identifier in SFRELID"
	exit 1
else
	$(XSLT) VERSION VERSION $(TMP)/fm-docbook-$(DISTRO) sf-relid=$(SFRELID)
	grep -v "<?xml" $(TMP)/fm-docbook-$(DISTRO) | freshmeat-submit $(FMGO)
endif

zip:
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
	exit 1
else
# normalize perms/filemodes for all files and dirs
	find . -type f | xargs chmod 0644
	find . -type d | xargs chmod 0755
# set executable bit on executables that are in all distributions
ifneq ($(EXECUTABLES),)
	chmod 0755 $(EXECUTABLES)
endif
# set executable bit on distro-specific executables
ifneq ($(DISTRIB_EXECUTABLES),)
	chmod 0755 $(DISTRIB_EXECUTABLES)
endif

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
	  find . -print  | grep "^./$$part\|^./$${part}src" | cut -c3- >> $(TMP)/tar.exclude; \
	done
endif
# tar up distro, then gzip/bzip/zip it
	$(TAR) cf$(TARFLAGS) - -X $(TMP)/tar.exclude * .[^.]* | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); $(TAR) xf$(TARFLAGS) -)
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && zip -q -rpD docbook-$(DISTRO)-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)
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
	$(TAR) cf$(TARFLAGS) - -X $(TMP)/tar.exclude --ignore-failed-read $$part $${part}src images | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); $(TAR) xf$(TARFLAGS) -); \
	umask 022; (cd $(TMP) && \
	if [ -d docbook-$(DISTRO)-$(ZIPVER)/images ]; \
	  then mv docbook-$(DISTRO)-$(ZIPVER)/images docbook-$(DISTRO)-$(ZIPVER)/doc/; \
	fi) ; \
	umask 022; (cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-$$part-$(ZIPVER).tar.gz); \
	umask 022; (cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-$$part-$(ZIPVER).tar.bz2); \
	umask 022; (cd $(TMP) && zip -q -rpD docbook-$(DISTRO)-$$part-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)); \
	$(RM) $(TMP)/tar.exclude; \
	done
endif
endif

install: zip
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-$(DISTRO)-*-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
	$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2 $(PROJECT_USER)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-*-$(ZIPVER).tar.bz2 $(PROJECT_USER)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	$(SSH) $(SSH_OPTS)-l $(PROJECT_USER) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   cd $(RELEASE_DIR)/$(DISTRO); \
	   rm -rf $(ZIPVER); \
	   $(TAR) xfj$(TARFLAGS) docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   $(TAR) xfj$(TARFLAGS) docbook-$(DISTRO)-*-$(ZIPVER).tar.bz2; \
	   mv docbook-$(DISTRO)-$(ZIPVER) $(ZIPVER); \
	   rm -rf docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   rm -rf docbook-$(DISTRO)-*-$(ZIPVER).tar.bz2; \
	   chmod -R g+w $(ZIPVER); \
	   $(RM) current; \
	   ln -s $(ZIPVER) current; \
	   )"

release-clean: clean
	$(RM) $(NEWSFILE)
	$(RM) NEWS.html
	$(RM) NEWS.xml
	$(RM) RELEASE-NOTES-$(TAGVER).xml
	$(RM) ChangeLog.xml
	$(RM) LatestTag
	$(RM) RELEASE-NOTES.txt
	$(RM) RELEASE-NOTES.html
	$(RM) RELEASE-NOTES.fo
	$(RM) RELEASE-NOTES.pdf
	$(RM) install.sh
	$(RM) .CatalogManager.properties.example
	$(RM) .urilist
	$(RM) .make-catalog.xsl
