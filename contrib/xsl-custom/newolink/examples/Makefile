# Makefile to demonstrate the use of
# newolink for linking between documents.

# User  guide and reference books

UG-BASEURI = "../docroot/UserGuide/userguide.html"
INCL-BASEURI = "../docroot/Modular/"
REF-BASEURI = "../docroot/Reference"


ugtargets.xml : userguide.xml
	xsltproc ../tools/targets.xsl userguide.xml > ugtargets.xml

reftargets.xml : ref.xml
	xsltproc ../tools/chunktargets.xsl ref.xml > reftargets.xml

# Single-file output user guide

$(UG-BASEURI) : userguide.xml reftargets.xml targetdb.xml ugtargets.xml
	test -d ../docroot/UserGuide || mkdir -p ../docroot/UserGuide
	xsltproc --param target.database.document '"../examples/targetdb.xml"' \
		../tools/custom.xsl userguide.xml > $(UG-BASEURI) 2> ug.err

# Chunked output reference

$(REF)/index.html : ref.xml ugtargets.xml targetdb.xml reftargets.xml
	test -d ../docroot/Reference || mkdir -p ../docroot/Reference
	xsltproc --param target.database.document '"../examples/targetdb.xml"' \
		 --output "../docroot/Reference/" \
		 --param quiet 1 \
		../tools/chunkcustom.xsl ref.xml  2> ref.err

ug : $(UG-BASEURI)

ref : $(REF)/index.html

all: ug ref

# Modular doc

SRC = modular.xml preface.xml introduction.xml

# Make the targets file
modtargets.xml : $(SRC)
	xsltproc --xinclude \
	../tools/chunktargets.xsl modular.xml > modtargets.xml

# Process the whole book
modular: modtargets.xml
	test -d ../docroot/Modular || mkdir -p ../docroot/Modular
	rm -f ../docroot/Modular/*
	xsltproc --param target.database.document '"../examples/targetdb.xml"' \
		--xinclude \
		 --output "../docroot/Modular/" \
		../tools/chunkcustom.xsl modular.xml 2> mod.err

# Process the preface only
preface : preface.xml
	xsltproc --param target.database.document '"../examples/targetdb.xml"' \
		--xinclude \
		 --output "../docroot/Modular/" \
		../tools/chunkcustom.xsl preface.xml 

# Process the chapter only
intro : introduction.xml
	xsltproc --param target.database.document '"../examples/targetdb.xml"' \
		--xinclude \
		 --output "../docroot/Modular/" \
		../tools/chunkcustom.xsl introduction.xml 
