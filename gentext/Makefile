XSLT=../cvstools/saxon
XJPARSE=../cvstools/xjparse

SOURCES=af.xml bg.xml bn.xml bs.xml ca.xml cs.xml da.xml de.xml el.xml en.xml es.xml \
	et.xml fi.xml fr.xml hu.xml id.xml it.xml ja.xml ko.xml lt.xml nl.xml  \
	no.xml pl.xml pt.xml pt_br.xml ro.xml ru.xml sk.xml sl.xml \
	sr.xml sr_Latn.xml sv.xml tr.xml zh_cn.xml zh_tw.xml

DSSSLENT=dbl1af.ent dbl1bg.ent dbl1bn.ent dbl1bs.ent dbl1ca.ent dbl1cs.ent dbl1da.ent \
	 dbl1de.ent dbl1el.ent dbl1en.ent dbl1es.ent dbl1et.ent dbl1fi.ent \
	 dbl1fr.ent dbl1hu.ent dbl1id.ent dbl1it.ent dbl1ja.ent dbl1ko.ent \
         dbl1lt.ent dbl1nl.ent dbl1no.ent dbl1pl.ent dbl1pt.ent dbl1ro.ent \
         dbl1ru.ent dbl1sk.ent dbl1sl.ent dbl1sr.ent dbl1srLatn.ent dbl1sv.ent \
         dbl1ptbr.ent dbl1zhcn.ent dbl1zhtw.ent

all:
	@echo ""
	@echo Choose a target: dsssl-files, xsl-files, or clean
	@echo ""

xsl-files: $(SOURCES)

dsssl-files: $(DSSSLENT)

dbl1af.ent: locale/af.xml
dbl1bg.ent: locale/bg.xml
dbl1bn.ent: locale/bn.xml
dbl1bs.ent: locale/bs.xml
dbl1ca.ent: locale/ca.xml
dbl1cs.ent: locale/cs.xml
dbl1da.ent: locale/da.xml
dbl1de.ent: locale/de.xml
dbl1el.ent: locale/el.xml
dbl1en.ent: locale/en.xml
dbl1es.ent: locale/es.xml
dbl1et.ent: locale/et.xml
dbl1fi.ent: locale/fi.xml
dbl1fr.ent: locale/fr.xml
dbl1hu.ent: locale/hu.xml
dbl1id.ent: locale/id.xml
dbl1it.ent: locale/it.xml
dbl1ja.ent: locale/ja.xml
dbl1ko.ent: locale/ko.xml
dbl1lt.ent: locale/lt.xml
dbl1nl.ent: locale/nl.xml
dbl1no.ent: locale/no.xml
dbl1pl.ent: locale/pl.xml
dbl1pt.ent: locale/pt.xml
dbl1ptbr.ent: locale/pt_br.xml
dbl1ro.ent: locale/ro.xml
dbl1ru.ent: locale/ru.xml
dbl1sk.ent: locale/sk.xml
dbl1sl.ent: locale/sl.xml
dbl1sr.ent: locale/sr.xml
dbl1srLatn.ent: locale/sr_Latn.xml
dbl1sv.ent: locale/sv.xml
dbl1zhcn.ent: locale/zh_cn.xml
dbl1zhtw.ent: locale/zh_tw.xml

%.xml: locale/%.xml
	$(XJPARSE) -w $<
	$(XSLT) locale/en.xml xsl/xsl.xsl $@ locale.file=$@

%.ent:
	$(XJPARSE) -w $<
	$(XSLT) $< xsl/dsssl.xsl $@

clean:
	rm -f *.ent *.xml
