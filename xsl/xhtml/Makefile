include $(DOCBOOK_SVN)/buildtools/Makefile.incl

TARGETNS=http://www.w3.org/1999/xhtml

all: xsl-files profile-docbook.xsl profile-chunk.xsl profile-onechunk.xsl

remove-old:
	for f in *.xsl; do if [ ! -f ../html/$$f -a "$$f" != "html2xhtml.xsl" ]; then rm $$f; fi; done
	$(RM) docbook.css.xml

add-new:
	for f in ../html/*.xsl; do if [ ! -f `basename $$f` ]; then \
          echo "copying $$f"; \
          cp $$f .; \
          touch -t 197001010000 `basename $$f`; fi; done
	cp ../html/docbook.css.xml .

# Oh, come on! It must be possible to do this in Make, but I can't figure out how (ndw)

xsl-files: remove-old add-new
	for f in *.xsl; do \
	  if [ ../html/$$f -nt $$f ]; then \
	    echo "transforming $$f"; \
	    $(XSLT) ../html/$$f html2xhtml.xsl $$f; \
	 fi; \
	done

	# Also Generate special docbook-no-doctype.xsl file
	$(XSLT) ../html/docbook.xsl html2xhtml.xsl docbook-no-doctype.xsl \
	        include.output.doctype=0 ;  \

profile-docbook.xsl: docbook.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

profile-chunk.xsl: chunk.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

profile-onechunk.xsl: onechunk.xsl ../profiling/xsl2profile.xsl
	$(XSLT) $< ../profiling/xsl2profile.xsl $@

clean: remove-old
	$(RM) profile-docbook.xsl profile-chunk.xsl profile-onechunk.xsl
	for f in ../html/*.xsl; do $(RM) `basename $$f`; done
