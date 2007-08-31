#-----------------------------------------------------------------
#  -*- makefile -*- snippet with VARIABLES FOR RELEASE BUILDS
#-----------------------------------------------------------------
# If you are doing normal (non-release) sandbox builds just for
# your own use, you can ignore all the variables below. They are
# used only when doing release builds.
#-----------------------------------------------------------------

# $Id$

include $(DOCBOOK_SVN)/buildtools/Makefile.incl

RELEASE_ANNOUNCE=$(DOCBOOK_SVN)/releasetools/release-announce
ANNOUNCE_RECIPIENTS=docbook-apps@lists.oasis-open.org
ANNOUNCE_CHANGES=RELEASE-NOTES-PARTIAL.txt
FRESHMEAT_SUBMIT=$(DOCBOOK_SVN)/releasetools/freshmeat-submit

CATALOGMANAGER=$(DOCBOOK_SVN)/releasetools/.CatalogManager.properties.example
INSTALL_SH=$(DOCBOOK_SVN)/releasetools/install.sh
MAKECATALOG=$(DOCBOOK_SVN)/releasetools/make-catalog.xsl

DOCBUILD_STYLESHEETS=$(DOCBOOK_SVN)/xsl/tools/xsl/build

PARAMPROF=$(VPATH)/.param.profiled
PARAMSTRIP=$(VPATH)/.param.stripped

# param.xml to param.html
LREFENTRY=$(DOCBUILD_STYLESHEETS)/lrefentry.xsl
# param.xml to param.html
CLREFENTRY=$(DOCBUILD_STYLESHEETS)/clrefentry.xsl
# pi.xml to pi.html
PIREFENTRY=$(DOCBUILD_STYLESHEETS)/pirefentry.xsl
# embedded doc in XSL files to jrefentry XML
XSL2JREF=$(DOCBUILD_STYLESHEETS)/xsl2jref.xsl
# jrefentry XML to HTML output
JREFHTML=$(DOCBUILD_STYLESHEETS)/jrefhtml.xsl
# jrefentry XML to DocBook Refsect1
JREF2REFSECT1=$(DOCBUILD_STYLESHEETS)/jref2refsect1.xsl

# RNG file to elements list
MAKE_ELEMENTS_XSL=$(DOCBUILD_STYLESHEETS)/make-elements.xsl
# XSL params files to params list
MAKE_PARAMS_XSL=$(DOCBUILD_STYLESHEETS)/make-xsl-params.xsl
# XSL PI files to PI list
MAKE_PI_XSL=$(DOCBUILD_STYLESHEETS)/make-xsl-pi.xsl
# generated elements list
DOCBOOK_ELEMENTS=$(DOCBUILD_STYLESHEETS)/docbook-elements.xsl
XSL_PARAMS=$(DOCBUILD_STYLESHEETS)/xsl-params.xsl
XSL_PI=$(DOCBUILD_STYLESHEETS)/xsl-pi.xsl
DOCPARAM2TXT=$(DOCBUILD_STYLESHEETS)/docparam2txt.xsl

# reference.xml to reference.html
RSTYLE=$(DOCBUILD_STYLESHEETS)/reference.xsl
# reference.dbk to reference.fo
REFERENCEFOXSL=$(DOCBUILD_STYLESHEETS)/reference-fo.xsl
# reference.dbk to reference.txt
REFERENCETXTXSL=$(DOCBUILD_STYLESHEETS)/reference-txt.xsl

# RELEASE-NOTES.xml to RELEASE-NOTES.html
DOC_LINK_STYLE=$(DOCBUILD_STYLESHEETS)/doc-link-docbook.xsl
DOC_BASEURI=http://docbook.sourceforge.net/release/xsl/current/doc/

# RELEASE-NOTES.xml to RELEASE-NOTES.pdf
DBX_STYLE=$(DOCBUILD_STYLESHEETS)/dblatex-release-notes.xsl

# MARKUP_XSL is a modified version of Jeni Tennison's "Markup Utility"
MARKUP_XSL=$(DOCBOOK_SVN)/releasetools/modified-markup.xsl

# stylesheet used in taking XML output from "svn log" and using it
# to generate NEWS file(s) and releases notes
SVNLOG2DOCBOOK=$(DOCBOOK_SVN)/releasetools/svnlog2docbook.xsl

SVN_INFO_FILE=.svninfo.xml

PREVIOUS_RELEASE=$(shell $(XSLTPROC) --stringparam get PreviousRelease VERSION VERSION)
DISTRO_TITLE=$(shell $(XSLTPROC) --stringparam get DistroTitle VERSION VERSION)

REPOSITORY_ROOT=$(shell if [ -f $(SVN_INFO_FILE) ]; then $(XSLTPROC) --stringparam expression //root $(EVALXPATH) $(SVN_INFO_FILE); fi)
DISTRO_URL=$(shell if [ -f $(SVN_INFO_FILE) ]; then $(XSLTPROC) --stringparam expression //url $(EVALXPATH) $(SVN_INFO_FILE); fi)
REVISION=$(shell if [ -f $(SVN_INFO_FILE) ]; then $(XSLTPROC) --stringparam expression //commit/@revision $(EVALXPATH) $(SVN_INFO_FILE); fi)
DISTRO_PARENT_URL=$(dir $(basename $(DISTRO_URL)))

# stylesheet for stripping DB5 namespace
STRIP_NS=$(DOCBOOK_SVN)/xsl/common/stripns.xsl

# stylesheet for generating FO version of release notes
FO_STYLE=$(DOCBOOK_SVN)/xsl/fo/docbook.xsl

# browser to use for making text version of release notes
# w3mmee is a fork of w3m; it provides a lot more options for
# charset handling; other possible values for BROWSER include
# "w3m" and "lynx" and "links" and "elinks"
BROWSER=w3mmee
BROWSER_OPTS=-dump

PDF_MAKER=dblatex

XEP = xep
XEP_FLAGS =

DBLATEX = dblatex
DBLATEX_FLAGS = -b pdftex

# file containing "What's New" info generated from Subversion log
NEWSFILE=NEWS

PREVIOUS_REVISION=$(shell $(XSLTPROC) --stringparam get PreviousReleaseRevision VERSION VERSION)

TAG=$(shell $(XSLTPROC) --stringparam get Tag VERSION VERSION)

# determine RELVER automatically by:
#
#   - figuring out if VERSION file exists
#   - checking to see if VERSION is an XSL stylesheet or not
#   - grabbing the version number from VERSION file based on
#     whether or not it is a stylesheet
#
RELVER := $(shell \
 if [ -f VERSION ]; then \
   if grep "<xsl:stylesheet" VERSION >/dev/null; then \
     grep "Version>.\+<" VERSION \
     | sed 's/^[^<]*<fm:Version>\(.\+\)<\/fm:Version>$$/\1/' \
     | tr -d "\n"; \
   else cat VERSION; \
   fi \
 fi \
)
ZIPVER=$(RELVER)

# the following are used to determine what version to compare to
# in order to create the WhatsNew file
NEXTVER=
DIFFVER=

# CVSCHECK is used to make sure your working directory is up to
# date with CVS. Note that we use a makefile conditional here
# because we want/need to check whether we're up to date only when
# the "newversion" target is called. Without the conditional, the
# right side of this variable assignment will get call every time
# make is run, regardless of the target. Which kind of tends to
# slow down things a bit...
ifeq ($@,newversion)
CVSCHECK = $(shell cvs -n update 2>&1 | grep -v ^cvs | cut -c3-)
endif

# remove dots from version number to create CVS tag
TAGVER := $(shell echo "V$(RELVER)" | sed "s/\.//g")

# if TMP is already defined in the environment, build uses that as
# location for temporary storage for files generated by "make
# zip"; otherwise it defaults to /tmp. To use a temp directory
# other than /tmp, run "make zip TMP=/foo" 
ifeq ($(TMP),)
TMP=/tmp
endif

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (regular expressions OK) that should be excluded
# from the *zip files for the release
ZIP_EXCLUDES = \
 /CVS$$ \
 /CVS/ \
 .*/\.svn \
 /debian \
 ~$$ \
 \..*\.pyc \
 \\\#.* \
 \.\\\#.* \
 prj\.el \
 \.cvsignore \
 Makefile$$ \
 Makefile.common \
 Makefile.incl \
 Makefile.tests \
 Makefile.param \
 ChangeLog\.xml \
 RELEASE-NOTES\.fo \
 \.make-catalog\.xsl \
 param\.ent$$ \
 .*\.xweb$$ \
 lib/lib\.xml$$ \
 \.announcement-text

# specifies options to feed to "freshmeat-submit"
FMGO=-N
# SFRELID specifies Sourceforge release ID for current release.
# Before running "make freshmeat", you need to manually create the
# new release at Sourceforge (via the SF web interface), then copy
# down the release ID in the URI for the release
SFRELID=
# specifies which FTP app to use for upload to SF incoming
FTP=lftp
FTP_OPTS=-e
SCP=scp
SCP_OPTS=
SSH=ssh
SSH_OPTS=
SF_UPLOAD_HOST=upload.sf.net
SF_UPLOAD_DIR=incoming
PROJECT_HOST=docbook.sf.net
RELEASE_DIR=/home/groups/d/do/docbook/htdocs/release
TAR=tar
TARFLAGS=P
ZIP=zip
ZIPFLAGS=-q -rpD
GZIP=gzip
GZIPFLAGS=

XSLTPROC=xsltproc
XSLTPROC_OPTS=

EVALXPATH=$(DOCBOOK_SVN)/releasetools/eval-xpath.xsl

XMLLINT=xmllint
XMLLINT_OPTS=--noent
XINCLUDE=$(XMLLINT) $(XMLLINT_OPTS) --xinclude

SVN=svn
SVN_OPTS=

SED=sed
SED_OPTS=
