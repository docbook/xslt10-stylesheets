
#-----------------------------------------------------------------
#                VARIABLES FOR RELEASE BUILDS
#-----------------------------------------------------------------
# If you are doing normal (non-release) sandbox builds just for
# your own use, you can ignore all the variables below. They are
# used only when doing release builds.
#-----------------------------------------------------------------

# stylesheet for generating release notes
DOC-LINK-STYLE=   $(DOCBOOK_CVS)/xsl/docsrc/doc-link-docbook.xsl

# browser to use for making text version of release notes
BROWSER=w3m
BROWSER_OPTS=-dump

# determine RELVER automatically by:
#
#   - figuring out if VERSION file exists
#   - checking to see if VERSION is an XSL stylesheet or not
#   - grabbing the version number from VERSION file based on
#     whether or not it is a stylesheet
#
RELVER := $(shell \
 if [ -f $(DISTRO)/VERSION ]; then \
   if grep "<xsl:stylesheet" $(DISTRO)/VERSION >/dev/null; then \
     grep "Version>.\+<" $(DISTRO)/VERSION \
     | sed 's/^[^<]*<fm:Version>\(.\+\)<\/fm:Version>$$/\1/' \
     | tr -d "\n"; \
   else cat $(DISTRO)/VERSION; \
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

# stuff for "make zip", "make freshmeat", and "make install" targets
TMP=/tmp
# specifies options to feed to "freshmeat-submit"
FMGO=-N
# SFRELID specifies the Sourceforge release ID for the current
# release. Before running "make freshmeat", you need to manually
# create the new release at Sourceforge (via the SF web
# interface), then copy down the release ID in the URI for the
# release
SFRELID=
# specifies with FTP app to use for upload to SF incoming
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
PROJECT_USER:=`sed 's/^:.\+:\([^@]\+\)@.\+$$/\1/' CVS/Root`
