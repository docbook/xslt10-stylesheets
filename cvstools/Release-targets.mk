# this file is a -*- makefile -*- snippet
# targets in the file are used only for release builds

RELEASE-NOTES.html: RELEASE-NOTES.xml
	$(XJPARSE) $<
	$(XSLT) $< $(DOC-LINK-STYLE) $@

RELEASE-NOTES.txt: RELEASE-NOTES.html
	$(BROWSER) $(BROWSER_OPTS) $< > $@

distrib: all $(DISTRIB_DEPENDS)
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > WhatsNew
else
	$(MERGELOGS) -v $(DIFFVER) > WhatsNew
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
	find . -type f | xargs chmod 0644
	find . -type d | xargs chmod 0755
ifneq ($(EXECUTABLES),)
	chmod 0755 $(EXECUTABLES)
endif
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	rm -f  $(TMP)/tar.exclude
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.gz
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip
	umask 022; mkdir -p $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	touch $(TMP)/tar.exclude
# distro-specific excludes
	for file in $(DISTRIB_EXCLUDES); do \
	  find . -print  | grep $$file     | cut -c3- >> $(TMP)/tar.exclude; \
	done
# global excludes
	find . -print  | grep /CVS$$       | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep /CVS/        | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep /debian/     | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep .classes     | cut -c3- >> $(TMP)/tar.exclude
	find . -print  | grep "~$$"        | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".*.pyc"      | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "#*"          | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".#*"         | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "prj.el"      | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name ".cvsignore"  | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "Makefile*"   | cut -c3- >> $(TMP)/tar.exclude
	find . -type f -name "README.CVS"  | cut -c3- >> $(TMP)/tar.exclude
	tar cf - * --exclude-from $(TMP)/tar.exclude | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); tar xf -)
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && zip -q -rpD docbook-$(DISTRO)-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)
	rm -f $(TMP)/tar.exclude
endif

install: zip
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
	$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2 $(PROJECT_USER)@$(PROJECT_HOST):$(PROJECT_BASE)/$(DISTRO)/
	$(SSH) $(SSH_OPTS)-l $(PROJECT_USER) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   cd $(PROJECT_BASE)/$(DISTRO); \
	   rm -rf $(ZIPVER); \
	   tar xfj docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   mv docbook-$(DISTRO)-$(ZIPVER) $(ZIPVER); \
	   rm -rf docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   chmod -R g+w $(ZIPVER); \
	   rm -f current; \
	   ln -s $(ZIPVER) current; \
	   if [ -d $(ZIPVER)/doc ] || [ -d $(ZIPVER)/images ]; then \
	   cd $(ZIPVER)/doc; \
	   ln -s ../images; \
	   fi \
	   )"
