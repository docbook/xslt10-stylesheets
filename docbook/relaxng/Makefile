.SUFFIXES: .rnc .rng .rnx
.PHONY: docbook.rng tests

all: docbook.rng

docbook.rng:
	$(MAKE) -C build $@
	cp build/$@ .

tests:
	mkdir -p tests tests/passed
	cd tests && ../tools/runtests

db5doc.xml: docbook.rng \
            tools/group.xsl tools/expand.xsl tools/flatten.xsl tools/classify.xsl
	xsltproc -output /tmp/gr1.xml  tools/group.xsl    $<
	xsltproc -output /tmp/out1.xml tools/expand.xsl   /tmp/gr1.xml
	xsltproc -output /tmp/out2.xml tools/expand.xsl   /tmp/out1.xml
	xsltproc -output /tmp/out3.xml tools/expand.xsl   /tmp/out2.xml
	xsltproc -output /tmp/out4.xml tools/expand.xsl   /tmp/out3.xml
	xsltproc -output /tmp/out5.xml tools/expand.xsl   /tmp/out4.xml
	xsltproc -output /tmp/out6.xml tools/classify.xsl /tmp/out5.xml
	xsltproc -output /tmp/out7.xml tools/flatten.xsl     /tmp/out6.xml
	xsltproc -output /tmp/out8.xml tools/flatten.xsl     /tmp/out7.xml
	xsltproc -output $@ tools/flatten.xsl     /tmp/out8.xml
	cp $@ /sourceforge/docbook/defguide/en/build/lib/

out.html: db5doc.xml
	saxon $< tools/html.xsl $@

clean:
	rm -f out*
