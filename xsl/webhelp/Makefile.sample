# Configuration
DOCBOOK_DIST := ../$(pwd)

DOCBOOK_EXTENSIONS_DIR = $(DOCBOOK_DIST)/extensions

INPUT_XML = docsrc/readme.xml
USER_IMAGES_PARENT_DIR=docsrc
OUTPUT_DIR = docs
INDEXER_EXCLUDED_FILES = ix01.html

INDEXER_JAR   := $(DOCBOOK_EXTENSIONS_DIR)/webhelpindexer.jar
TAGSOUP_JAR   := $(DOCBOOK_EXTENSIONS_DIR)/tagsoup-1.2.1.jar
LUCENE_ANALYZER_JAR   := $(DOCBOOK_EXTENSIONS_DIR)/lucene-analyzers-3.0.0.jar
LUCENE_CORE_JAR   := $(DOCBOOK_EXTENSIONS_DIR)/lucene-core-3.0.0.jar

classpath := $(INDEXER_JAR):$(TAGSOUP_JAR):$(LUCENE_ANALYZER_JAR):$(LUCENE_CORE_JAR)

all: webhelp

webhelp: $(INPUT_XML) copyfiles chunk index

copyfiles:
	-rm -rf $(OUTPUT_DIR)
	mkdir -p $(OUTPUT_DIR)
	cp -r template/common ${OUTPUT_DIR}
	test ! -d $(USER_IMAGES_PARENT_DIR)/images/ || cp -r $(USER_IMAGES_PARENT_DIR)/images ${OUTPUT_DIR}/images
	cp template/favicon.ico ${OUTPUT_DIR}/

chunk:
	xsltproc  --output  xincluded-profiled.xml  \
                  --stringparam  profile.os  "linux" \
                  ../profiling/profile.xsl  \
                  ${INPUT_XML}

	xsltproc --xinclude xsl/webhelp.xsl xincluded-profiled.xml      

	rm xincluded-profiled.xml
index:
	java \
                -DhtmlDir=$(OUTPUT_DIR) \
                -DindexerLanguage=en \
                -DhtmlExtension=html \
                -DdoStem=true \
                -DindexerExcludedFiles=$(INDEXER_EXCLUDED_FILES) \
                -Dorg.xml.sax.driver=org.ccil.cowan.tagsoup.Parser \
                -Djavax.xml.parsers.SAXParserFactory=org.ccil.cowan.tagsoup.jaxp.SAXFactoryImpl \
                -classpath $(classpath) \
                com.nexwave.nquindexer.IndexerMain

	cp -r template/content/search/* ${OUTPUT_DIR}/search

clean:
	$(RM) -r docs/*

