all: jars

jars: saxon64.jar xalan2.jar

saxon64.jar:
	$(MAKE) -C saxon64/.classes
	cd saxon64/.classes; jar cf saxon64.jar `find com -name "*.class" -print`
	cd ../..
	mv saxon64/.classes/saxon64.jar .

xalan2.jar:
	$(MAKE) -C xalan2/.classes
	cd xalan2/.classes; jar cf xalan2.jar `find com -name "*.class" -print`
	cd ../..
	mv xalan2/.classes/xalan2.jar .

clean:
	$(MAKE) -C saxon64/.classes clean
	$(MAKE) -C xalan2/.classes clean
	rm -rf *.jar

realclean: clean
	$(MAKE) -C saxon64/.classes realclean
	$(MAKE) -C xalan2/.classes realclean
