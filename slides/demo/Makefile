XSLTPROC=saxon
SLIDES=../source/slides.xml
XSLT=$(XSLTPROC) $(SLIDES)

all: default plain tables vslides w3c frames browser graphics

frames: frames1 frames2 frames3 frames4 frames5 frames6 frames7

.PHONY: browser graphics \
        default plain tables vslides w3c \
        frames1 frames2 frames3 frames4 frames5 frames6 frames7

browser:
	cd browser && cp ../../browser/*.css ../../browser/*.js ../../browser/*.js .

graphics:
	cd ../graphics && tar cf - `find . -type f -name "*.gif" -o -name "*.png"` | (cd ../demo/graphics; tar xvf -)

default:
	cd default && rm -f *.html && $(XSLT) ../../xsl/xhtml/default.xsl

plain:
	cd plain && rm -f *.html && $(XSLT) ../../xsl/xhtml/plain.xsl

tables:
	cd tables && rm -f *.html && $(XSLT) ../../xsl/xhtml/tables.xsl

vslides:
	cd vslides && rm -f *.html && $(XSLT) ../../xsl/xhtml/vslides.xsl

w3c:
	cd w3c && rm -f *.html && $(XSLT) ../../xsl/xhtml/w3c.xsl

frames1:
	cd frames1 && rm -f *.html && $(XSLT) ../../xsl/xhtml/frames.xsl overlay=0 multiframe=0 dynamic.toc=0 active.toc=0

frames2:
	cd frames2 && rm -f *.html && $(XSLT) ../../xsl/xhtml/frames.xsl overlay=1 multiframe=0 dynamic.toc=0 active.toc=0

frames3:
	cd frames3 && rm -f *.html && $(XSLT) ../../xsl/xhtml/frames.xsl overlay=0 multiframe=1 dynamic.toc=0 active.toc=0

frames4:
	cd frames4 && rm -f *.html && $(XSLT) ../../xsl/xhtml/frames.xsl overlay=0 multiframe=0 dynamic.toc=1 active.toc=0

frames5:
	cd frames5 && rm -f *.html && $(XSLT) ../../xsl/xhtml/frames.xsl overlay=0 multiframe=0 dynamic.toc=0 active.toc=1

frames6:
	cd frames6 && rm -f *.html && $(XSLT) ../../xsl/xhtml/frames.xsl overlay=1 multiframe=0 dynamic.toc=1 active.toc=1

frames7:
	cd frames7 && rm -f *.html && $(XSLT) ../../xsl/xhtml/frames.xsl overlay=0 multiframe=1 dynamic.toc=1 active.toc=1
