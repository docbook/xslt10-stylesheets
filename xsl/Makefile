DIFFVER=

.PHONY : distrib clean doc

all:
	cd common; make
	cd html; make
	cd fo; make
	cd extensions; make

doc:
	cd docsrc; make
	cd doc; make

distrib: all doc
	dbin/cvs2log -w
ifeq ($(DIFFVER),)
	dbin/mergechangelogs > WhatsNew
else
	dbin/mergechangelogs -v $(DIFFVER) > WhatsNew
endif

newversion:
	dbin/nextversion
	make DIFFVER=$(DIFFVER) distrib

clean:
	cd doc; make clean
	cd test; make clean

