# $Id: Makefile 7877 2008-03-08 04:07:52Z xmldoc $

all: saxon65.jar xalan27.jar webhelpindexer.jar xslt.py docbook.py README.LIBXSLT

saxon65.jar: $(repo_dir)/xsl-saxon/saxon65.jar
	cp -p $^ $@

xalan27.jar: $(repo_dir)/xsl-xalan/xalan27.jar
	cp -p $^ $@

webhelpindexer.jar: $(repo_dir)/xsl-webhelpindexer/webhelpindexer.jar
	cp -p $^ $@
	cp -p $(repo_dir)/xsl-webhelpindexer/lib/*.jar .
	cp -p $(repo_dir)/xsl-webhelpindexer/*.txt .

$(repo_dir)/xsl-saxon/saxon65.jar: $(wildcard $(repo_dir)/xsl-saxon/src/com/nwalsh/saxon/*.java) 
	$(MAKE) -C $(dir $@)

$(repo_dir)/xsl-xalan/xalan27.jar: $(wildcard $(repo_dir)/xsl-xalan/src/com/nwalsh/xalan/*.java) 
	$(MAKE) -C $(dir $@)

$(repo_dir)/xsl-webhelpindexer/webhelpindexer.jar: $(wildcard $(repo_dir)/xsl-webhelpindexer/src/com/nexwave/*/*.java) 
	$(MAKE) -C $(dir $@)

xslt.py: $(repo_dir)/xsl-libxslt/python/xslt.py
	cp -p $^ $@

docbook.py: $(repo_dir)/xsl-libxslt/python/docbook.py
	cp -p $^ $@

README.LIBXSLT: $(repo_dir)/xsl-libxslt/python/README.LIBXSLT
	cp -p $^ $@

clean:
	$(RM) saxon65.jar
	$(RM) xalan27.jar
	$(RM) webhelpindexer.jar
	$(RM) xslt.py
	$(RM) docbook.py
	$(RM) README.LIBXSLT
