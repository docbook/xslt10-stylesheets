export repo_dir ?= $(abspath .)

all:
	$(MAKE) -C xsl

version:
	@$(MAKE) -s -C xsl version

doc:
	$(MAKE) -C xsl doc

check:
	$(MAKE) -C xsl check

dist:
	$(MAKE) -C xsl release
	$(MAKE) -C xsl zip-nons TMP=$(repo_dir)/dist

clean:
	$(MAKE) -C xsl clean
