.PHONY: doc saxon642 saxon643 saxon644 xalan2

all: jars

saxon642:
	make -C saxon642/.classes

saxon643:
	make -C saxon643/.classes

saxon644: saxon643
	@echo Saxon 6.4.4 is compatible with Saxon 6.4.3

xalan2:
	make -C xalan2/.classes

jars: saxon642 saxon643 saxon644 xalan2
	make -C saxon642/.classes jar
	make -C saxon643/.classes jar
	cp saxon643.jar saxon644.jar
	make -C xalan2/.classes jar

clean:
	make -C saxon642/.classes clean
	make -C saxon643/.classes clean
	make -C xalan2/.classes clean
