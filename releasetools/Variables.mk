#-----------------------------------------------------------------
#  -*- makefile -*- snippet with VARIABLES FOR RELEASE BUILDS
#-----------------------------------------------------------------
# If you are doing normal (non-release) sandbox builds just for
# your own use, you can ignore all the variables below. They are
# used only when doing release builds.
#-----------------------------------------------------------------

include $(repo_dir)/buildtools/Makefile.incl

RELEASE_ANNOUNCE=$(repo_dir)/releasetools/release-announce
ANNOUNCE_RECIPIENTS=docbook-apps@lists.oasis-open.org
ANNOUNCE_CHANGES=RELEASE-NOTES-PARTIAL.txt

CATALOGMANAGER=$(repo_dir)/releasetools/.CatalogManager.properties.example
INSTALL_SH=$(repo_dir)/releasetools/install.sh
ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
MAKECATALOG=../releasetools/make-catalog.xsl
else
MAKECATALOG=$(repo_dir)/releasetools/make-catalog.xsl
endif
else
MAKECATALOG=$(repo_dir)/releasetools/make-catalog.xsl
endif

ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
DOCBUILD_STYLESHEETS=../../xsl/tools/xsl/build
RELEASEDOC_STYLESHEETS=../xsl/tools/xsl/build
else
DOCBUILD_STYLESHEETS=$(repo_dir)/xsl/tools/xsl/build
RELEASEDOC_STYLESHEETS=$(repo_dir)/xsl/tools/xsl/build
endif
else
DOCBUILD_STYLESHEETS=$(repo_dir)/xsl/tools/xsl/build
RELEASEDOC_STYLESHEETS=$(repo_dir)/xsl/tools/xsl/build
endif

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
DOCBOOK_ELEMENTS=$(RELEASEDOC_STYLESHEETS)/docbook-elements.xsl
XSL_PARAMS=$(RELEASEDOC_STYLESHEETS)/xsl-params.xsl
XSL_PI=$(RELEASEDOC_STYLESHEETS)/xsl-pi.xsl
DOCPARAM2TXT=$(RELEASEDOC_STYLESHEETS)/docparam2txt.xsl

# reference.xml to reference.html
RSTYLE=$(DOCBUILD_STYLESHEETS)/reference.xsl
# reference.dbk to reference.fo
REFERENCEFOXSL=$(DOCBUILD_STYLESHEETS)/reference-fo.xsl
# reference.dbk to reference.txt
REFERENCETXTXSL=$(DOCBUILD_STYLESHEETS)/reference-txt.xsl

# RELEASE-NOTES.xml to RELEASE-NOTES.html
DOC_LINK_STYLE=$(RELEASEDOC_STYLESHEETS)/doc-link-docbook.xsl
DOC_BASEURI=https://cdn.docbook.org/release/xsl/current/doc/

# RELEASE-NOTES.xml to RELEASE-NOTES.pdf
DBX_STYLE=$(RELEASEDOC_STYLESHEETS)/dblatex-release-notes.xsl

# MARKUP_XSL is a modified version of Jeni Tennison's "Markup Utility"
ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
MARKUP_XSL=$(repo_dir)/releasetools/modified-markup.xsl
else
MARKUP_XSL=../releasetools/modified-markup.xsl
endif
else
MARKUP_XSL=$(repo_dir)/releasetools/modified-markup.xsl
endif

GITLOG2DOCBOOK=$(repo_dir)/releasetools/gitlog2docbook.xsl

PREVIOUS_RELEASE=$(shell $(XSLTPROC) --stringparam get PreviousRelease VERSION.xsl VERSION.xsl | $(GREP) $(GREPFLAGS) -v "xml version=")
DISTRO_TITLE=$(shell $(XSLTPROC) --stringparam get DistroTitle VERSION.xsl VERSION.xsl | $(GREP) $(GREPFLAGS) -v "xml version=")

# stylesheet for stripping DB5 namespace
STRIP_NS=common/stripns.xsl

# stylesheet for generating FO version of release notes
FO_STYLE=fo/docbook.xsl

# BROWSER is the Web browser to use for dumpin a text version of
# release notes; text output from w3m looks better than that from
# elinks or lynx; but w3m sometimes hangs unexpectedly under OSX;
# setting GC_NPROCS=1 prevents it from hanging
BROWSER = GC_NPROCS=1 w3m
BROWSER_OPTS = -dump

PDF_MAKER=dblatex

XEP = xep
XEP_FLAGS = -valid -quiet

DBLATEX = dblatex
DBLATEX_FLAGS = -b pdftex

# file containing "What's New" info generated from Subversion log
NEWSFILE=NEWS

PREVIOUS_REVISION=$(shell $(XSLTPROC) --stringparam get PreviousReleaseRevision VERSION.xsl VERSION.xsl | $(GREP) $(GREPFLAGS) -v "xml version=")

TAG=$(shell $(XSLTPROC) --stringparam get Tag VERSION.xsl VERSION.xsl | $(GREP) $(GREPFLAGS) -v "xml version=")

RELVER=$(shell if [ -f VERSION.xsl ]; then xsltproc --stringparam get VERSION VERSION.xsl VERSION.xsl | grep -v "xml version="; fi)
ZIPVER=$(RELVER)

ifeq (snapshot,$(findstring snapshot,$(RELVER)))
  RELEASE_TYPE=snapshot
else
ifeq (-pre,$(findstring -pre,$(RELVER)))
  RELEASE_TYPE=snapshot
else
ifeq (.0,$(findstring .0,$(RELVER)))
  RELEASE_TYPE=dot-zero
else
  RELEASE_TYPE=dot-one-plus
endif
endif
endif

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
 \.gitignore \
 Makefile$$ \
 Makefile.common \
 Makefile.incl \
 Makefile.param \
 ChangeLog\.xml \
 RELEASE-NOTES\.fo \
 \.make-catalog\.xsl \
 param\.ent$$ \
 .*\.xweb$$ \
 lib/lib\.xml$$ \
 \.announcement-text

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

ifneq ($(shell uname -s | grep -i cygwin),)
ifeq ($(XSLTENGINE),saxon)
EVALXPATH=../releasetools/eval-xpath.xsl
else
EVALXPATH=$(repo_dir)/releasetools/eval-xpath.xsl
endif
else
EVALXPATH=$(repo_dir)/releasetools/eval-xpath.xsl
endif

XMLLINT=xmllint
XMLLINT_OPTS=--noent
XINCLUDE=$(XMLLINT) $(XMLLINT_OPTS) --xinclude

SED=sed
SED_OPTS=

GREP=egrep
GREPFLAGS=

TAIL=tail
TAILFLAGS=
