XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

SOURCES=af.xml \
        ca.xml cs.xml da.xml de.xml el.xml en.xml es.xml et.xml eu.xml fi.xml \
        fr.xml hu.xml id.xml it.xml ja.xml ko.xml nl.xml nn.xml no.xml pl.xml \
        pt.xml pt_br.xml ro.xml ru.xml sk.xml sl.xml sr.xml sv.xml \
        tr.xml uk.xml xh.xml zh_cn.xml zh_tw.xml

GENSTYLE=../../gentext/xsl/xsl.xsl

all: $(SOURCES)

af.xml: ../../gentext/locale/af.xml $(GENSTYLE)
ca.xml: ../../gentext/locale/ca.xml $(GENSTYLE)
cs.xml: ../../gentext/locale/cs.xml $(GENSTYLE)
da.xml: ../../gentext/locale/da.xml $(GENSTYLE)
de.xml: ../../gentext/locale/de.xml $(GENSTYLE)
el.xml: ../../gentext/locale/el.xml $(GENSTYLE)
en.xml: ../../gentext/locale/en.xml $(GENSTYLE)
es.xml: ../../gentext/locale/es.xml $(GENSTYLE)
et.xml: ../../gentext/locale/et.xml $(GENSTYLE)
eu.xml: ../../gentext/locale/eu.xml $(GENSTYLE)
fi.xml: ../../gentext/locale/fi.xml $(GENSTYLE)
fr.xml: ../../gentext/locale/fr.xml $(GENSTYLE)
hu.xml: ../../gentext/locale/hu.xml $(GENSTYLE)
id.xml: ../../gentext/locale/id.xml $(GENSTYLE)
it.xml: ../../gentext/locale/it.xml $(GENSTYLE)
ja.xml: ../../gentext/locale/ja.xml $(GENSTYLE)
ko.xml: ../../gentext/locale/ko.xml $(GENSTYLE)
nl.xml: ../../gentext/locale/nl.xml $(GENSTYLE)
nn.xml: ../../gentext/locale/nn.xml $(GENSTYLE)
no.xml: ../../gentext/locale/no.xml $(GENSTYLE)
pl.xml: ../../gentext/locale/pl.xml $(GENSTYLE)
pt.xml: ../../gentext/locale/pt.xml $(GENSTYLE)
pt_br.xml: ../../gentext/locale/pt_br.xml $(GENSTYLE)
ro.xml: ../../gentext/locale/ro.xml $(GENSTYLE)
ru.xml: ../../gentext/locale/ru.xml $(GENSTYLE)
sk.xml: ../../gentext/locale/sk.xml $(GENSTYLE)
sl.xml: ../../gentext/locale/sl.xml $(GENSTYLE)
sr.xml: ../../gentext/locale/sr.xml $(GENSTYLE)
sv.xml: ../../gentext/locale/sv.xml $(GENSTYLE)
tr.xml: ../../gentext/locale/tr.xml $(GENSTYLE)
uk.xml: ../../gentext/locale/uk.xml $(GENSTYLE)
xh.xml: ../../gentext/locale/xh.xml $(GENSTYLE)
zh_cn.xml: ../../gentext/locale/zh_cn.xml $(GENSTYLE)
zh_tw.xml: ../../gentext/locale/zh_tw.xml $(GENSTYLE)

%.xml:
	$(XJPARSE) -w $<
	$(XSLT) $< ../../gentext/xsl/xsl.xsl $@

clean:
	rm -f *.ent *.xml
