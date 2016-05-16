export repo_dir ?= $(abspath .)

all:
	$(MAKE) -C xsl release

check:
	$(MAKE) -C xsl check

dist:
	$(MAKE) -C xsl zip-ns TMP=$(repo_dir)/dist
