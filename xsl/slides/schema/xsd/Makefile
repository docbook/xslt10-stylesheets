include ../../../../buildtools/Makefile.incl

all: slides.xsd

slides.xsd: ../relaxng/slides.rnc
	trang $< $@

clean:

maintainer-clean: clean
	rm -f *.xsd
