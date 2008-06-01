# $Id: Makefile 7877 2008-03-08 04:07:52Z xmldoc $

all: saxon65.jar xalan27.jar xslt.py docbook.py README.LIBXSLT

saxon65.jar: $(DOCBOOK_SVN)/xsl-saxon/saxon65.jar
	cp -p $^ $@

xalan27.jar: $(DOCBOOK_SVN)/xsl-xalan/xalan27.jar
	cp -p $^ $@

$(DOCBOOK_SVN)/xsl-saxon/saxon65.jar: $(wildcard ../../xsl-saxon/src/com/nwalsh/saxon/*.java) 
	$(MAKE) -C $(dir $@)

$(DOCBOOK_SVN)/xsl-xalan/xalan27.jar: $(wildcard ../../xsl-xalan/src/com/nwalsh/xalan/*.java) 
	$(MAKE) -C $(dir $@)

xslt.py: $(DOCBOOK_SVN)/xsl-libxslt/python/xslt.py
	cp -p $^ $@

docbook.py: $(DOCBOOK_SVN)/xsl-libxslt/python/docbook.py
	cp -p $^ $@

README.LIBXSLT: $(DOCBOOK_SVN)/xsl-libxslt/python/README.LIBXSLT
	cp -p $^ $@

clean:
	$(RM) saxon65.jar
	$(RM) xalan27.jar
	$(RM) xslt.py
	$(RM) docbook.py
	$(RM) README.LIBXSLT
