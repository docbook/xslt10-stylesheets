include ../../../buildtools/Makefile.incl

all: website.dtd

website.dtd: website-custom.dtd forms.mod
	$(FLATTEN) $< > $@

clean:

realclean: clean
	rm -f website.dtd
