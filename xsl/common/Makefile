XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

SOURCES=ca.xml cs.xml da.xml de.xml el.xml en.xml es.xml et.xml fi.xml \
          fr.xml hu.xml id.xml it.xml ja.xml ko.xml nl.xml no.xml pl.xml \
          pt.xml pt_br.xml ro.xml ru.xml sk.xml sl.xml sr.xml sv.xml \
          tr.xml zh_cn.xml zh_tw.xml

all: $(SOURCES)

ca.xml: ../../gentext/locale/ca.xml
cs.xml: ../../gentext/locale/cs.xml
da.xml: ../../gentext/locale/da.xml
de.xml: ../../gentext/locale/de.xml
el.xml: ../../gentext/locale/el.xml
en.xml: ../../gentext/locale/en.xml
es.xml: ../../gentext/locale/es.xml
et.xml: ../../gentext/locale/et.xml
fi.xml: ../../gentext/locale/fi.xml
fr.xml: ../../gentext/locale/fr.xml
hu.xml: ../../gentext/locale/hu.xml
id.xml: ../../gentext/locale/id.xml
it.xml: ../../gentext/locale/it.xml
ja.xml: ../../gentext/locale/ja.xml
ko.xml: ../../gentext/locale/ko.xml
nl.xml: ../../gentext/locale/nl.xml
no.xml: ../../gentext/locale/no.xml
pl.xml: ../../gentext/locale/pl.xml
pt.xml: ../../gentext/locale/pt.xml
pt_br.xml: ../../gentext/locale/pt_br.xml
ro.xml: ../../gentext/locale/ro.xml
ru.xml: ../../gentext/locale/ru.xml
sk.xml: ../../gentext/locale/sk.xml
sl.xml: ../../gentext/locale/sl.xml
sr.xml: ../../gentext/locale/sr.xml
sv.xml: ../../gentext/locale/sv.xml
tr.xml: ../../gentext/locale/tr.xml
zh_cn.xml: ../../gentext/locale/zh_cn.xml
zh_tw.xml: ../../gentext/locale/zh_tw.xml

%.xml:
	$(XJPARSE) -w $<
	$(XSLT) $< ../../gentext/xsl/xsl.xsl $@

clean:
	rm -f *.ent *.xml
