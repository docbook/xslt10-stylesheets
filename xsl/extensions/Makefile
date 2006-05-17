ANT = ant
ANT_OPTS =

all: jars

jars: saxon643.jar xalan25.jar xalan27.jar

saxon643.jar: build/lib/docbook-xsl-saxon.jar
	cp build/lib/docbook-xsl-saxon.jar saxon643.jar
	cp saxon643.jar saxon644.jar
	cp saxon643.jar saxon65.jar
	cp saxon643.jar saxon651.jar
	cp saxon643.jar saxon652.jar
	cp saxon643.jar saxon653.jar

xalan25.jar: build/lib/docbook-xsl-xalan.jar
	cp build/lib/docbook-xsl-xalan.jar xalan25.jar

xalan27.jar: build2/lib/docbook-xsl-xalan27.jar
	cp build2/lib/docbook-xsl-xalan27.jar xalan27.jar

build/lib/docbook-xsl-saxon.jar:
	$(ANT) jar.saxon

build/lib/docbook-xsl-xalan.jar:
	CLASSPATH=/usr/share/java/xalan25.jar:$$CLASSPATH \
	$(ANT) jar.xalan

build2/lib/docbook-xsl-xalan27.jar:
	$(ANT) jar.xalan27

clean:
	$(ANT) clean
	$(RM) *.jar
