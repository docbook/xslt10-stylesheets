# this file is a -*- makefile -*- snippet
# targets in this file are used to build and upload the namespaced
# version of the DocBook Project XSL Stylesheets

zip-ns: zip
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	rm -rf $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)
	$(RM)  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).tar.gz
	$(RM)  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).tar.bz2
	$(RM)  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER).zip
	(cd $(TMP) && \
	  unzip -qq $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip && \
	  $(repo_dir)/releasetools/xslns-build \
	  docbook-$(DISTRO)-$(ZIPVER) \
	  docbook-$(DISTRO)-ns-$(ZIPVER)); 


# Run xslt on xsl/webhelp/docsrc/readme.xml
	$(XSLT) \
	$(TMP)/docbook-$(DISTRO)-$(ZIPVER)/webhelp/docsrc/readme.xml \
	$(repo_dir)/xsl/tools/xsl/build/db4-upgrade.xsl \
	$(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/webhelp/docsrc/readme.xml 
	$(XSLT) \
	$(TMP)/docbook-$(DISTRO)-$(ZIPVER)/webhelp/docsrc/xinclude-test.xml \
	$(repo_dir)/xsl/tools/xsl/build/db4-upgrade.xsl \
	$(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/webhelp/docsrc/xinclude-test.xml 

# Turn off validation in webhelp:
	sed -i"" "s/validate-against-dtd=true/validate-against-dtd=false/" \
	  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/webhelp/build.properties

# change branch info
	sed -i"" "s/^\(.*\)<fm:Branch>XSL Stylesheets<\/fm:Branch>$$/\1<fm:Branch>XSL-NS Stylesheets<\/fm:Branch>/" \
	  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/VERSION

# change distro name









	sed -i"" "s/^\(.*\)<xsl:param name=\"DistroName\">docbook-xsl<\/xsl:param>$$/\1<xsl:param name=\"DistroName\">docbook-xsl-ns<\/xsl:param>/" \
	  $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/VERSION

# fix catalog.xml file
	$(XSLT) .make-catalog.xsl .make-catalog.xsl \
	  DISTRO="$(DISTRO)-ns" BRANCH="XSL-NS" \
	  | $(XMLLINT) $(XMLLINT_OPTS) --format --encode utf-8 - \
	  > $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/catalog.xml

# repair perms
	chmod 755 $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/fo/pdf2index
	chmod 755 $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/install.sh
	chmod 755 $(TMP)/docbook-$(DISTRO)-ns-$(ZIPVER)/tools/bin/docbook-xsl-update

# gzip/bzip/zip it
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-ns-$(ZIPVER) \
	| gzip >  docbook-$(DISTRO)-ns-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && $(TAR) cf$(TARFLAGS) - docbook-$(DISTRO)-ns-$(ZIPVER) \
	| bzip2 > docbook-$(DISTRO)-ns-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && $(ZIP) $(ZIPFLAGS) docbook-$(DISTRO)-ns-$(ZIPVER).zip \
	 docbook-$(DISTRO)-ns-$(ZIPVER)

announce-ns: announce
	$(RELEASE_ANNOUNCE) "XSL-NS Stylesheets" "$(RELVER)" \
	  $(repo_dir)/releasetools/xslnsfiles/announcement-text \
	  $(ANNOUNCE_CHANGES) \
	 "$(ANNOUNCE_RECIPIENTS)"
