# Configuration
INDEXER_JAR   := ../extensions/webhelpindexer.jar
TAGSOUP_JAR   := ../extensions/tagsoup-1.2.1.jar
LUCENE_ANALYZER_JAR   := ../extensions/lucene-analyzers-3.0.0.jar
LUCENE_CORE_JAR   := ../extensions/lucene-core-3.0.0.jar

classpath := $(INDEXER_JAR):$(TAGSOUP_JAR):$(LUCENE_ANALYZER_JAR):$(LUCENE_CORE_JAR)

all: webhelp

webhelp: docs/index.html

docs/index.html: docsrc/readme.xml
	-rm -rf docs
	mkdir -p docs
	cp -r template/common docs/
	test ! -d docsrc/images/ || cp -r docsrc/images docs/images
	cp template/favicon.ico docs/
	xsltproc  --xinclude --output  xincluded-profiled.xml  \
          --stringparam  profile.os  "linux" \
          ../profiling/profile.xsl  \
           $<
	xsltproc xsl/webhelp.xsl xincluded-profiled.xml
	rm xincluded-profiled.xml
	java \
          -DhtmlDir=docs \
          -DindexerLanguage=en \
          -DhtmlExtension=html \
          -DdoStem=true \
          -DindexerExcludedFiles=ix01.html \
          -Dorg.xml.sax.driver=org.ccil.cowan.tagsoup.Parser \
          -Djavax.xml.parsers.SAXParserFactory=org.ccil.cowan.tagsoup.jaxp.SAXFactoryImpl \
          -classpath $(classpath) \
          com.nexwave.nquindexer.IndexerMain
	cp -r template/search/* docs/search

clean:
	$(RM) -r docs/*

