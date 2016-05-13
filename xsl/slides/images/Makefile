faces=face1.gif face2.gif face3.gif face4.gif

all: $(faces)
	$(MAKE) -C callouts

clean:
	rm ./face*
	$(MAKE) -C callouts clean

%.gif: ../slidy/graphics/%.gif
	cp $< $@
