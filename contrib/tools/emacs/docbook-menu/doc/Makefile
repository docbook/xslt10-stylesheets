# $Id$
#
# ::: Basic makefile for generating HTML and HTML Help from DocBook XML source files
#
# $DateTime: 2003/10/14 03:36:19 $
# $Author$

SCP          = scp
SCP_OPTS     =
REMOTE_HOST  = atlantis.io.com
UPLOAD_DIR   = /virtual/customer/logopoeia.com/htdocs/docbook

# HTML stuff
HTML_STYLESHEET    = make-html.xsl
ROOT_FILENAME      = docbook-menu
XSLTPROC           = xsltproc
XSLTPROC_OPTS      =
XSLTPROC_HTML_OPTS = --stringparam root.filename "$(ROOT_FILENAME)"
MANIFEST           = HTML.manifest

# HTML Help stuff
HELP_STYLESHEET    = make-help.xsl
XSLTPROC_HELP_OPTS = --stringparam base.dir "$(HELP_BASE_DIR)" \
		     --stringparam htmlhelp.chm "$(HTMLHELP_CHM)"
HELP_BASE_DIR      = help/
HTMLHELP_CHM       = docbook-menu.chm
HTMLHELP_HHP       = htmlhelp.hhp
HTMLHELP_HHC       = toc.hhc
HTMLHELP_HHK       = index.hhk

all: html help
html: $(ROOT_FILENAME).html
help: $(HTMLHELP_CHM)
install:
	$(SCP) $(SCP_OPTS) *.html $(REMOTE_HOST):$(UPLOAD_DIR)

$(ROOT_FILENAME).html: docbook-menu.xml
	@echo
	@echo "Making HTML output..."
	xsltproc $(XSLTPROC_HTML_OPTS) $(HTML_STYLESHEET) $?

$(HTMLHELP_CHM): docbook-menu.xml
	@echo
	@echo "Making HTML Help output..."
	xsltproc $(XSLTPROC_HELP_OPTS) $(HELP_STYLESHEET) $?
	-hhc $(HTMLHELP_HHP)
	chmod 664 $(HTMLHELP_CHM)
	rm -rf $(HELP_BASE_DIR) $(HTMLHELP_HHP) $(HTMLHELP_HHC) $(HTMLHELP_HHK)

clean:
	-xargs rm < $(MANIFEST)
	-rm $(MANIFEST)
	-rm $(HTMLHELP_CHM)
