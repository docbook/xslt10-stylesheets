.PHONY: doc saxon642 saxon643 xalan2

all: jars

saxon642:
	make -C saxon642/.classes

saxon643:
	make -C saxon643/.classes

xalan2:
	make -C xalan2/.classes

jars: saxon642 saxon643 xalan2
	make -C saxon642/.classes jar
	make -C saxon643/.classes jar
	make -C xalan2/.classes jar

clean:
	make -C saxon642/.classes clean
	make -C saxon643/.classes clean
	make -C xalan2/.classes clean
