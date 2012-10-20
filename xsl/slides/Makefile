include $(DOCBOOK_SVN)/buildtools/Makefile.incl

DIRS = fo xhtml

base:
	for i in $(DIRS); do \
	  echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
	done

clean:
	for i in $(DIRS); do \
	  echo "$(MAKE) -C $$i clean"; $(MAKE) -C $$i clean; \
	done
	rm xhtml/params.xsl
