PARAMBASE=param
ALLTARGETS=param.xml

include $(repo_dir)/buildtools/Makefile.incl

profile_files:=$(patsubst %, profile-%.xsl, docbook chunk onechunk)
upstream_xsl:=$(wildcard ../html/*.xsl)
xsl_files:=$(patsubst ../html/%.xsl, %.xsl, $(upstream_xsl))
xsl_files:=$(filter-out html2xhtml.xsl $(profile_files), $(xsl_files))

all: $(xsl_files) $(profile_files) docbook.css.xml

clean:
	$(RM) $(xsl_files) $(profile_files)

$(xsl_files): %.xsl: ../html/%.xsl
	$(XSLT) $< html2xhtml.xsl $@

$(profile_files): profile-%.xsl: %.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

docbook.css.xml: ../html/docbook.css.xml
	cp $< $@
