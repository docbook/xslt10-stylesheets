# this file is a -*- makefile -*- snippet
# targets in the file are used only for release builds

# $Id$

RELEASE-NOTES.html: RELEASE-NOTES.xml
	$(XJPARSE) $<
	$(XSLT) $< $(DOC-LINK-STYLE) $@

RELEASE-NOTES.txt: RELEASE-NOTES.html
	$(BROWSER) $(BROWSER_OPTS) $< > $@

.CatalogManager.properties.example:
	cp -p $(CATALOGMANAGER) .CatalogManager.properties.example

.urilist:
	for uri in $(URILIST); do \
	echo $$uri >> .urilist; \
	done

install.sh: .CatalogManager.properties.example .urilist
	cp -p $(INSTALL_SH) install.sh

distrib: all $(DISTRIB_DEPENDS) $(NEWSFILE) install.sh

$(NEWSFILE):
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > $(NEWSFILE)
else
	$(MERGELOGS) -v $(DIFFVER) > $(NEWSFILE)
endif

newversion:
ifeq ($(CVSCHECK),)
ifeq ($(DIFFVER),)
	@echo "DIFFVER must be specified."
	exit 1
else
ifeq ($(NEXTVER),$(RELVER))
	cvs tag $(TAGVER)
	$(MAKE) DIFFVER=$(DIFFVER) distrib
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
	rm -f  $(TMP)/tar.exclude
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.gz
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip
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
	tar cf - * .[^.]* --exclude-from $(TMP)/tar.exclude | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); tar xf -)
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && zip -q -rpD docbook-$(DISTRO)-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)
	rm -f $(TMP)/tar.exclude

# -----------------------------------------------------------------
#     Prepare *zip files for other parts of distro (if any)
# -----------------------------------------------------------------
ifneq ($(DISTRIB_PACKAGES),)
	for part in $(DISTRIB_PACKAGES); do \
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER); \
	rm -f  $(TMP)/tar.exclude; \
	rm -f  $(TMP)/docbook-$(DISTRO)-$$part-$(ZIPVER).tar.gz; \
	rm -f  $(TMP)/docbook-$(DISTRO)-$$part-$(ZIPVER).tar.bz2; \
	rm -f  $(TMP)/docbook-$(DISTRO)-$$part-$(ZIPVER).zip; \
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
	tar cf - --ignore-failed-read $$part $${part}src images --exclude-from $(TMP)/tar.exclude | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); tar xf -); \
	umask 022; (cd $(TMP) && \
	if [ -d docbook-$(DISTRO)-$(ZIPVER)/images ]; \
	  then mv docbook-$(DISTRO)-$(ZIPVER)/images docbook-$(DISTRO)-$(ZIPVER)/doc/; \
	fi) ; \
	umask 022; (cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-$$part-$(ZIPVER).tar.gz); \
	umask 022; (cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-$$part-$(ZIPVER).tar.bz2); \
	umask 022; (cd $(TMP) && zip -q -rpD docbook-$(DISTRO)-$$part-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)); \
	rm -f $(TMP)/tar.exclude; \
	done
endif
endif

install: zip
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
	$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2 $(PROJECT_USER)@$(PROJECT_HOST):$(RELEASE_DIR)/$(DISTRO)/
	$(SSH) $(SSH_OPTS)-l $(PROJECT_USER) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   cd $(RELEASE_DIR)/$(DISTRO); \
	   rm -rf $(ZIPVER); \
	   tar xfj docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   mv docbook-$(DISTRO)-$(ZIPVER) $(ZIPVER); \
	   rm -rf docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   chmod -R g+w $(ZIPVER); \
	   rm -f current; \
	   ln -s $(ZIPVER) current; \
	   )"
