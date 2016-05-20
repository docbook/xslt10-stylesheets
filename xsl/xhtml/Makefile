include $(repo_dir)/buildtools/Makefile.incl

TARGETNS=http://www.w3.org/1999/xhtml

profile_files:=$(patsubst %, profile-%.xsl, docbook chunk onechunk)
upstream_xsl:=$(wildcard ../html/*.xsl)
xsl_files:=$(patsubst ../html/%.xsl, %.xsl, $(upstream_xsl))
xsl_files:=$(filter-out html2xhtml.xsl $(profile_files), $(xsl_files))

all: $(xsl_files) $(profile_files) docbook-no-doctype.xsl

clean:
	$(RM) $(xsl_files) $(profile_files)

$(xsl_files): %.xsl: ../html/%.xsl
	$(XSLT) $< html2xhtml.xsl $@

$(profile_files): profile-%.xsl: %.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

docbook-no-doctype.xsl: ../html/docbook.xsl
	$(XSLT) $< html2xhtml.xsl docbook-no-doctype.xsl include.output.doctype=0

