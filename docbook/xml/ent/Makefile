SOURCES=iso-amsa.ent iso-amsb.ent iso-amsc.ent iso-amsn.ent \
        iso-amso.ent iso-amsr.ent iso-box.ent iso-cyr1.ent iso-cyr2.ent \
        iso-dia.ent iso-grk1.ent iso-grk2.ent iso-grk3.ent iso-grk4.ent \
        iso-lat1.ent iso-lat2.ent iso-num.ent iso-pub.ent iso-tech.ent

all: $(SOURCES)

%.ent:
	cp ../../../xmlcharent/$@ $@

clean:
	rm -f *.ent
