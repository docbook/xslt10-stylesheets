.PHONY: doc saxon64 xalan2

all: jars

saxon64:
	make -C saxon64/.classes

xalan2:
	make -C xalan2/.classes

jars: saxon64 xalan2
	make -C saxon64/.classes jar
	make -C xalan2/.classes jar

clean:
	make -C saxon64/.classes clean
	make -C xalan2/.classes clean
