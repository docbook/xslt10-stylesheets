include ../../cvstools/Makefile.incl

OLDVER=
NEWVER=

distrib:
	$(MAKE) -C ../spec SPEVER=$(NEWVER)
	$(DTDDISTRIB) -d -v $(OLDVER) -n $(NEWVER)
