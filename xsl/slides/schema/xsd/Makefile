include ../../../../buildtools/Makefile.incl

all: slides.xsd

slides.xsd: ../relaxng/slides.rnc
	trang $< $@

clean:
	rm -rf *.xsd
