XSLT=../../cvstools/saxon
XJPARSE=../../cvstools/xjparse

PARAMS=../params/admon.graphics.xml \
       ../params/admon.graphics.extension.xml \
       ../params/admon.graphics.path.xml \
       ../params/admon.style.xml \
       ../params/annotate.toc.xml \
       ../params/author.othername.in.middle.xml \
       ../params/base.dir.xml \
       ../params/biblioentry.item.separator.xml \
       ../params/bibliography.collection.xml \
       ../params/bridgehead.in.toc.xml \
       ../params/callout.defaultcolumn.xml \
       ../params/callout.graphics.xml \
       ../params/callout.graphics.extension.xml \
       ../params/callout.graphics.number.limit.xml \
       ../params/callout.graphics.path.xml \
       ../params/callout.list.table.xml \
       ../params/callout.unicode.xml \
       ../params/callout.unicode.font.xml \
       ../params/callout.unicode.number.limit.xml \
       ../params/callout.unicode.start.character.xml \
       ../params/callouts.extension.xml \
       ../params/chapter.autolabel.xml \
       ../params/chunk.first.sections.xml \
       ../params/chunk.sections.xml \
       ../params/citerefentry.link.xml \
       ../params/css.decoration.xml \
       ../params/default.encoding.xml \
       ../params/default.table.width.xml \
       ../params/emphasis.propagates.style.xml \
       ../params/formal.procedures.xml \
       ../params/funcsynopsis.decoration.xml \
       ../params/funcsynopsis.style.xml \
       ../params/function.parens.xml \
       ../params/generate.appendix.toc.xml \
       ../params/generate.article.toc.xml \
       ../params/generate.book.toc.xml \
       ../params/generate.chapter.toc.xml \
       ../params/generate.component.toc.xml \
       ../params/generate.division.toc.xml \
       ../params/generate.index.xml \
       ../params/generate.part.toc.xml \
       ../params/generate.preface.toc.xml \
       ../params/generate.qandadiv.toc.xml \
       ../params/generate.qandaset.toc.xml \
       ../params/generate.reference.toc.xml \
       ../params/generate.section.toc.xml \
       ../params/generate.section.toc.level.xml \
       ../params/generate.set.toc.xml \
       ../params/graphic.default.extension.xml \
       ../params/html.base.xml \
       ../params/html.longdesc.xml \
       ../params/html.longdesc.link.xml \
       ../params/html.ext.xml \
       ../params/html.stylesheet.xml \
       ../params/html.stylesheet.type.xml \
       ../params/inherit.keywords.xml \
       ../params/label.from.part.xml \
       ../params/linenumbering.everyNth.xml \
       ../params/linenumbering.extension.xml \
       ../params/linenumbering.separator.xml \
       ../params/linenumbering.width.xml \
       ../params/link.mailto.url.xml \
       ../params/make.single.year.ranges.xml \
       ../params/make.year.ranges.xml \
       ../params/nominal.table.width.xml \
       ../params/part.autolabel.xml \
       ../params/phrase.propagates.style.xml \
       ../params/preface.autolabel.xml \
       ../params/process.empty.source.toc.xml \
       ../params/process.source.toc.xml \
       ../params/qanda.defaultlabel.xml \
       ../params/qanda.inherit.numeration.xml \
       ../params/qandadiv.autolabel.xml \
       ../params/refentry.generate.name.xml \
       ../params/refentry.separator.xml \
       ../params/refentry.xref.manvolnum.xml \
       ../params/root.filename.xml \
       ../params/rootid.xml \
       ../params/runinhead.default.title.end.punct.xml \
       ../params/runinhead.title.end.punct.xml \
       ../params/saxon.callouts.xml \
       ../params/saxon.character.representation.xml \
       ../params/saxon.linenumbering.xml \
       ../params/saxon.tablecolumns.xml \
       ../params/section.autolabel.xml \
       ../params/section.label.includes.component.label.xml \
       ../params/show.comments.xml \
       ../params/show.revisionflag.xml \
       ../params/spacing.paras.xml \
       ../params/stylesheet.result.type.xml \
       ../params/suppress.navigation.xml \
       ../params/tablecolumns.extension.xml \
       ../params/textinsert.extension.xml \
       ../params/toc.list.type.xml \
       ../params/toc.section.depth.xml \
       ../params/ulink.target.xml \
       ../params/use.extensions.xml \
       ../params/use.id.as.filename.xml \
       ../params/use.id.function.xml \
       ../params/using.chunker.xml \
       ../params/appendix.autolabel.xml \
       ../params/olink.fragid.xml \
       ../params/olink.outline.ext.xml \
       ../params/olink.pubid.xml \
       ../params/olink.sysid.xml \
       ../params/olink.resolver.xml \
       ../params/refentry.separator.xml \
       ../params/shade.verbatim.xml \
       ../params/shade.verbatim.style.xml \
       ../params/ebnf.table.bgcolor.xml \
       ../params/ebnf.table.border.xml \
       ../params/autotoc.label.separator.xml \
       ../params/chunk.datafile.xml \
       ../params/saxon.character.representation.xml \
       ../params/generate.legalnotice.link.xml \
       ../params/table.borders.with.css.xml \
       ../params/table.border.thickness.xml \
       ../params/table.border.style.xml \
       ../params/table.border.color.xml

all: titlepage.templates.xsl param.xsl

xml: param.xml

html: param.html

param.html: param.xml
	$(XSLT) $< ../docsrc/lrefentry.xsl $@

param.xml: param.xweb $(PARAMS)
	$(XSLT) $< ../../litprog/wdocbook.xsl $@

param.xsl: param.xweb $(PARAMS)
	$(XSLT) $< ../../litprog/xtangle.xsl $@

titlepage.templates.xsl: titlepage.templates.xml ../template/titlepage.xsl
	$(XSLT) $< ../template/titlepage.xsl $@
