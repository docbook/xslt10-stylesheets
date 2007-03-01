include ../../buildtools/Makefile.incl

OLDVER=
NEWVER=

distrib:
	$(MAKE) -C ../spec SPECVER=$(NEWVER)
	$(DTDDISTRIB) -d -v $(OLDVER) -n $(NEWVER)
