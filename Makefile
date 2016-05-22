export repo_dir ?= $(abspath .)

all:
	$(MAKE) -C xsl

doc:
	$(MAKE) -C xsl doc

check:
	$(MAKE) -C xsl check

dist:
	$(MAKE) -C xsl release
	$(MAKE) -C xsl zip-ns TMP=$(repo_dir)/dist

clean:
	$(MAKE) -C xsl clean
