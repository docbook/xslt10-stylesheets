include ../../../cvstools/Makefile.incl

all: slides.dtd

slides.dtd: slides-custom.dtd slides.mod
	$(FLATTEN) $< > $@

clean:

realclean: clean
	rm -f slides.dtd
