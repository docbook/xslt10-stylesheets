XSLT=../buildtools/saxon
XJPARSE=../buildtools/xjparse

SOURCES=af.xml am.xml ar.xml as.xml ast.xml az.xml bg.xml bn.xml bn_in.xml bs.xml \
	ca.xml cs.xml cy.xml da.xml de.xml el.xml en.xml eo.xml es.xml et.xml \
	eu.xml fa.xml fi.xml fr.xml ga.xml gl.xml gu.xml he.xml hi.xml hr.xml \
	hu.xml id.xml is.xml it.xml ja.xml ka.xml kn.xml ko.xml ky.xml la.xml \
	lt.xml lv.xml ml.xml mn.xml mr.xml nb.xml nds.xml nl.xml nn.xml or.xml \
	pa.xml pl.xml pt.xml pt_br.xml ro.xml ru.xml se.xml sk.xml sl.xml sq.xml sr.xml \
	sr_Latn.xml sv.xml ta.xml te.xml th.xml tl.xml tr.xml uk.xml vi.xml xh.xml \
	zh.xml zh_cn.xml zh_tw.xml

DSSSLENT=dbl1af.ent dbl1am.ent dbl1ar.ent dbl1as.ent dbl1ast.ent dbl1az.ent \
	dbl1bg.ent dbl1bn.ent dbl1bnin.ent dbl1bs.ent dbl1ca.ent dbl1cs.ent \
	dbl1cy.ent dbl1da.ent dbl1de.ent dbl1el.ent dbl1en.ent dbl1eo.ent \
	dbl1es.ent dbl1et.ent dbl1eu.ent dbl1fa.ent dbl1fi.ent dbl1fr.ent \
	dbl1ga.ent dbl1gl.ent dbl1gu.ent dbl1he.ent dbl1hi.ent dbl1hr.ent \
	dbl1hu.ent dbl1id.ent dbl1is.ent dbl1it.ent dbl1ja.ent dbl1ka.ent \
	dbl1kn.ent dbl1ko.ent dbl1ky.ent dbl1la.ent dbl1lt.ent dbl1lv.ent \
	dbl1ml.ent dbl1mn.ent dbl1mr.ent dbl1nb.ent dbl1nds.ent dblnl.ent \
	dblnn.ent dbl1or.ent dbl1pa.ent dbl1pl.ent dbl1pt.ent dbl1ptbr.ent \
	dbl1ro.ent dbl1ru.ent dbl1se.ent dbl1sk.ent dbl1sl.ent dbl1sq.ent dbl1sr.ent \
	dbl1srLatn.ent dbl1sv.ent dbl1ta.ent dbl1te.ent dbl1th.ent dbl1tl.ent \
	dbl1tr.ent dbl1uk.ent dbl1vi.ent dbl1xh.ent dbl1zh.ent dbl1zhcn.ent \
	dbl1zhtw.ent

all:
	@echo ""
	@echo Choose a target: dsssl-files, xsl-files, or clean
	@echo ""

xsl-files: $(SOURCES)

dsssl-files: $(DSSSLENT)

dbl1af.ent: locale/af.xml
dbl1am.ent: locale/am.xml
dbl1ar.ent: locale/ar.xml
dbl1as.ent: locale/as.xml
dbl1ast.ent: locale/ast.xml
dbl1az.ent: locale/az.xml
dbl1bg.ent: locale/bg.xml
dbl1bn.ent: locale/bn.xml
dbl1bnin.ent: locale/bn_in.xml
dbl1bs.ent: locale/bs.xml
dbl1ca.ent: locale/ca.xml
dbl1cs.ent: locale/cs.xml
dbl1cy.ent: locale/cy.xml
dbl1da.ent: locale/da.xml
dbl1de.ent: locale/de.xml
dbl1el.ent: locale/el.xml
dbl1en.ent: locale/en.xml
dbl1eo.ent: locale/eo.xml
dbl1es.ent: locale/es.xml
dbl1et.ent: locale/et.xml
dbl1eu.ent: locale/eu.xml
dbl1fa.ent: locale/fa.xml
dbl1fi.ent: locale/fi.xml
dbl1fr.ent: locale/fr.xml
dbl1ga.ent: locale/ga.xml
dbl1gl.ent: locale/gl.xml
dbl1gu.ent: locale/gu.xml
dbl1he.ent: locale/he.xml
dbl1hi.ent: locale/hi.xml
dbl1hr.ent: locale/hr.xml
dbl1hu.ent: locale/hu.xml
dbl1id.ent: locale/id.xml
dbl1is.ent: locale/is.xml
dbl1it.ent: locale/it.xml
dbl1ja.ent: locale/ja.xml
dbl1ka.ent: locale/ka.xml
dbl1kn.ent: locale/kn.xml
dbl1ko.ent: locale/ko.xml
dbl1ky.ent: locale/ky.xml
dbl1la.ent: locale/la.xml
dbl1lt.ent: locale/lt.xml
dbl1lv.ent: locale/lv.xml
dbl1ml.ent: locale/ml.xml
dbl1mn.ent: locale/mn.xml
dbl1mr.ent: locale/mr.xml
dbl1nb.ent: locale/nb.xml
dbl1nds.ent: locale/nds.xml
dbl1nl.ent: locale/nl.xml
dbl1nn.ent: locale/nn.xml
dbl1or.ent: locale/or.xml
dbl1pa.ent: locale/pa.xml
dbl1pl.ent: locale/pl.xml
dbl1pt.ent: locale/pt.xml
dbl1ptbr.ent: locale/pt_br.xml
dbl1ro.ent: locale/ro.xml
dbl1ru.ent: locale/ru.xml
dbl1se.ent: locale/se.xml
dbl1sk.ent: locale/sk.xml
dbl1sl.ent: locale/sl.xml
dbl1sq.ent: locale/sq.xml
dbl1sr.ent: locale/sr.xml
dbl1srLatn.ent: locale/sr_Latn.xml
dbl1sv.ent: locale/sv.xml
dbl1ta.ent: locale/ta.xml
dbl1te.ent: locale/te.xml
dbl1th.ent: locale/th.xml
dbl1tl.ent: locale/tl.xml
dbl1tr.ent: locale/tr.xml
dbl1uk.ent: locale/uk.xml
dbl1vi.ent: locale/vi.xml
dbl1xh.ent: locale/xh.xml
dbl1zh.ent: locale/zh.xml
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
