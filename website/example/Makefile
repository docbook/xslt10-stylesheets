PROC=saxon
PROCOPT=

.PHONY : clean

all: test

test:
	xjparse website.xml
ifeq ($(PROC),xt)
	$(PROC) $(PROCOPT) website.xml ../xsl/xtchunk-website.xsl
else
	$(PROC) $(PROCOPT) website.xml ../xsl/chunk-website.xsl
endif

tabular:
	xnsgmls -sv -c /share/doctypes/catalog website.xml
ifeq ($(PROC),xt)
	$(PROC) $(PROCOPT) website.xml ../xsl/xtchunk-tabular.xsl
else
	$(PROC) $(PROCOPT) website.xml ../xsl/chunk-tabular.xsl
endif

clean:
	rm -f *.html subdir/*.html

