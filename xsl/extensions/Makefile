.PHONY: doc saxon551 saxon6 saxon61 saxon63 xalan2

all: saxon551 saxon6 saxon61 saxon63 xalan2

saxon551:
	make -C saxon551/.classes

saxon6:
	make -C saxon6/.classes

saxon61:
	make -C saxon61/.classes

saxon63:
	make -C saxon63/.classes

xalan2:
	make -C xalan2/.classes

jars: saxon551 saxon6 saxon61 saxon63 xalan2
	make -C saxon551/.classes jar
	make -C saxon6/.classes jar
	make -C saxon61/.classes jar
	make -C saxon63/.classes jar
	make -C xalan2/.classes jar

clean:
	make -C saxon551/.classes clean
	make -C saxon6/.classes clean
	make -C saxon61/.classes clean
	make -C saxon63/.classes clean
	make -C xalan2/.classes clean
