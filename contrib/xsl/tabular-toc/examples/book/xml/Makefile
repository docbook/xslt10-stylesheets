#
# build chunked tabular html from a book
#
TOPDIR  := $(shell /bin/pwd)

XMLFILES =book.001.xml

CATALOGS=XML_CATALOG_FILES=$(TOPDIR)/catalog.xml
ENV=$(CATALOGS)

PROC=xsltproc  --nonet --novalid


#export TOPDIR  ENV PROC 

all:  ../html/index.html 

# a specific rule
#
../html/index.html: $(XMLFILES)



#
# A general rule.
# First convert the relative path down to the sourcefile into a 
# relative path back up to the root, in a crude manner. 
# It only works if there is one target dependency besides autolayout.xml
#

empty:=
space:= $(empty) $(empty)

%.html: 
	RELATIVE="$(subst //,/,$(subst $(space),/,$(patsubst %,..$(space), $(patsubst .$(space),,$(subst /,$(space),$(dir $(strip $(filter-out autolayout.xml,$^))))))))" ; \
	  $(ENV) $(PROC) --xinclude \
	       --stringparam  base.dir  "../html/"  \
	       --stringparam  chunker.output.encoding  "iso-8859-1"  \
	       --stringparam  html.stylesheet  "$${RELATIVE}book.css"  \
	       --stringparam  html.stylesheet.type  "text/css"  \
	       --stringparam  textdata.default.encoding  "iso-8859-1"  \
	       --stringparam  chunker.output.method  "html"  \
	       --stringparam  chunker.output.omit-xml-declaration  "no"  \
	       --stringparam  chunker.output.indent "yes"  \
	       --stringparam  current.docid  "symmetry"  \
	       --stringparam  admon.graphics.extension  ".png"  \
	       --stringparam  admon.graphics  "1" \
	       --stringparam  admon.graphics.path  "graphics/"  \
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
#	       --stringparam  autolayout-file "$${RELATIVE}autolayout.xml" \
#	       --stringparam  target.database.document  "$${RELATIVE}olinkdb.xml" \
#	       --stringparam  bibliography.collection  "$${RELATIVE}biblio.collection.xml" \
#	       --param  toc.expand.depth  2  \
#

.PHONY : clean

