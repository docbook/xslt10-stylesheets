all:
	@echo ""
	@echo Choose a target: dsssl-files, xsl-files, or clean
	@echo ""

test:
	xjparse locale/l10n.xml

dsssl-files:
	saxon locale/l10n.xml xsl/dsssl.xsl

xsl-files:
	saxon locale/l10n.xml xsl/xsl.xsl

clean:
	rm -f *.ent *.xml

