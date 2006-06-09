all: duck.html

duck.html: duck.xml
	../bin/areaoverlay $<
	saxon $< /sourceforge/docbook/xsl2/html/docbook.xsl $@
	tidy $@

clean:
	rm duck.html
	rm figures/duck*-co.png
