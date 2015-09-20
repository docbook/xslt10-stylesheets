#
# build a website out of dictionaries
TOPDIR  := $(shell /bin/pwd)

XMLFILES =coverpage.xml

SUBDIRS  =ddl1 ddl2 ddl3 databases 

TOOLDIR  = $(TOPDIR)/tools

BASEDIR  := $(TOPDIR)/html/

CATALOGS=XML_CATALOG_FILES=$(TOPDIR)/catalog.xml
ENV=$(CATALOGS)

PROC=xsltproc  --nonet --novalid

MAKEDEPENDSTYLE=../../../xsl/html/website-makefile-dep.xsl



export TOPDIR TOOLDIR ENV PROC STYLEDIR BASEDIR MAKEDEPENDSTYLE

all:    do-it-all

#
# Make "config" the default target if there is no configuration file or
# "depend" the target if there is no top-level dependency information.
#
DEPENDFILE=depends.tabular

ifeq ($(DEPENDFILE),$(wildcard $(DEPENDFILE)))
include $(DEPENDFILE)
do-it-all:      website
else
CONFIGURATION = depend
do-it-all:      depend
endif


depend dep: depends


TOPRELDIR  =#
CURRENTDIR =#


#
# Dependency rules
#

depends:  $(TOPDIR)/autolayout.xml  
	rm -f $(DEPENDFILE)
	$(ENV) $(PROC) --xinclude  \
	   --output  $(DEPENDFILE)  \
	   --stringparam  output-root  "$(TOPRELDIR)../html"  \
	   --stringparam  html.ext  ".html"  \
	   $(MAKEDEPENDSTYLE) \
	   $<

#	   --stringparam  source-dir  "$(CURRENTDIR)"  


olinks: websiteolinks

websiteolinks:  thespec/olinkdb.xml 

#
#   A general rule to make olink database supplements from .dbk XMLfiles 
#   
#

%olinkdb.xml: 
	RELATIVE="$(subst //,/,$(subst $(space),/,$(patsubst %,..$(space), $(patsubst .$(space),,$(subst /,$(space),$(dir $(strip $(filter-out autolayout.xml,$^))))))))" ; \
	  $(ENV) $(PROC) --xinclude \
	       --stringparam  collect.xref.targets  "only"  \
	       --stringparam  targets.filename  "$@"  \
	       --stringparam  base.dir  "../html/"  \
	       --stringparam  autolayout-file "$${RELATIVE}autolayout.xml" \
	       --stringparam  website.database.document "$${RELATIVE}website.database.xml" \
	       --stringparam  target.database.document  "$${RELATIVE}olinkdb.xml" \
	       --stringparam  chunker.output.encoding  "iso-8859-1"  \
	       --stringparam  html.stylesheet  "$${RELATIVE}ontology.css"  \
	       --stringparam  html.stylesheet.type  "text/css"  \
	       --stringparam  textdata.default.encoding  "iso-8859-1"  \
	       --stringparam  chunker.output.method  "html"  \
	       --stringparam  chunker.output.omit-xml-declaration  "no"  \
	       --stringparam  chunker.output.indent "yes"  \
	       --param  variablelist.as.table  1  \
	       --param  phrase.propagates.style  1  \
	       --param  use.id.as.filename  1  \
	       --param  sequential.links   1  \
	       --param  chunk.section.depth  -1  \
	       --param  chunk.first.sections  1  \
	       --param  toc.expand.depth  2  \
	       --param  website  1  \
	       --param  tabular  1  \
	       ../xsl/custom.xsl \
	       $(filter-out autolayout.xml,$^)


#  Here  autolayout.xml is hand crafted and encapsulates (using --xinclude)
#  the disparate autolayout.xml files in the dictionary directories
#  
#
#  first time: create empty file:  depends.tabular 
#              run:                make depends
#
#  thereafter: run:                make
#


#
# A general rule. The specific rules are in the $(DEPENDFILE) file.
# First convert the relative path down to the sourcefile into a 
# relative path back up to the root, in a crude manner. 
# It only works if there is one target dependency besides autolayout.xml
#

empty:=
space:= $(empty) $(empty)

%.html:   autolayout.xml  
	RELATIVE="$(subst //,/,$(subst $(space),/,$(patsubst %,..$(space), $(patsubst .$(space),,$(subst /,$(space),$(dir $(strip $(filter-out autolayout.xml,$^))))))))" ; \
	  $(ENV) $(PROC) --xinclude \
	       --stringparam  base.dir  "../html/"  \
	       --stringparam  autolayout-file "$${RELATIVE}autolayout.xml" \
	       --stringparam  target.database.document  "$${RELATIVE}olinkdb.xml" \
	       --stringparam  chunker.output.encoding  "iso-8859-1"  \
	       --stringparam  html.stylesheet  "$${RELATIVE}website.css"  \
	       --stringparam  html.stylesheet.type  "text/css"  \
	       --stringparam  textdata.default.encoding  "iso-8859-1"  \
	       --stringparam  chunker.output.method  "html"  \
	       --stringparam  chunker.output.omit-xml-declaration  "no"  \
	       --stringparam  chunker.output.indent "yes"  \
	       --stringparam  current.docid  "symmetry"  \
	       --stringparam  admon.graphics.extension  ".png"  \
	       --stringparam  admon.graphics  "1" \
	       --stringparam  admon.graphics.path  "graphics/"  \
	       --param  olink.debug  1  \
	       --param  variablelist.as.table  1  \
	       --param  use.id.as.filename  1  \
	       --param  sequential.links   1  \
	       --param  chunk.section.depth  99  \
	       --param  chunk.first.sections  1  \
	       --param  website  1  \
	       --param  tabular  1  \
	       ../xsl/custom.xsl \
	       $(filter-out autolayout.xml,$^)
	if [ -f $(shell dirname $@ )/Makefile ] ; then \
	       cd  $(shell dirname $@ ) && ${MAKE} ; fi
     

# This selects the target output file.
#	       --output $@  
# Unfortunately then chunked output goes to $@/$base.dir
#              so don't do that.
#
#	       --stringparam  target.database.document  "$${RELATIVE}olinkdb.xml" \
#	       --stringparam  bibliography.collection  "$${RELATIVE}biblio.collection.xml" \
#	       --param  toc.expand.depth  2  \
#

.PHONY : clean

