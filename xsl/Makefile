CVS2LOG=../cvstools/cvs2log
MERGELOGS=../cvstools/mergechangelogs
NEXTVER=../cvstools/nextversion
DIFFVER=

DIRS=common html fo extensions

.PHONY : distrib clean doc

all:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

doc:
	$(MAKE) -C docsrc
	$(MAKE) -C doc

distrib: all doc
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > WhatsNew
else
	$(MERGELOGS) -v $(DIFFVER) > WhatsNew
endif

newversion:
	$(NEXTVER)
	make DIFFVER=$(DIFFVER) distrib

clean:
	$(MAKE) -C doc clean
