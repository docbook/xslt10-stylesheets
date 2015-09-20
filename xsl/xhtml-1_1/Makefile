PARAMBASE=param
ALLTARGETS=param.xml

include $(DOCBOOK_SVN)/buildtools/Makefile.incl

all: xsl-files profile-docbook.xsl profile-chunk.xsl profile-onechunk.xsl

remove-old:
	for f in *.xsl; do if [ ! -f ../html/$$f -a "$$f" != "html2xhtml.xsl" ]; then rm $$f; fi; done

add-new:
	for f in ../html/*.xsl; do if [ ! -f `basename $$f` ]; then \
          echo $$f; \
          cp $$f .; \
          touch -t 197001010000 `basename $$f`; fi; done

# Oh, come on! It must be possible to do this in Make, but I can't figure out how (ndw)

xsl-files: remove-old add-new
	for f in *.xsl; do if [ ../html/$$f -nt $$f ]; then $(XSLT) ../html/$$f html2xhtml.xsl $$f; fi; done

profile-docbook.xsl: docbook.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

profile-chunk.xsl: chunk.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

profile-onechunk.xsl: onechunk.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean: remove-old
	$(RM) profile-docbook.xsl profile-chunk.xsl profile-onechunk.xsl
	for f in ../html/*.xsl; do $(RM) `basename $$f`; done
