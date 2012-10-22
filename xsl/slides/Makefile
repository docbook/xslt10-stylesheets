include ../../buildtools/Makefile.incl

subdirs:=schema images fo xhtml

base:
	for d in $(subdirs); do \
	  $(MAKE) -C $$d; \
	done

clean:
	for d in $(subdirs); do \
	  $(MAKE) -C $$d clean; \
	done
	rm xhtml/params.xsl
