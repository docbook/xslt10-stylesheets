include ../../../../buildtools/Makefile.incl

all: slides.rng

%.rng: %.rnc
	trang $< $@

clean:

maintainer-clean: clean
	rm -f slides.rng
