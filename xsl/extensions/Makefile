.PHONY: doc saxon551 saxon6 saxon61 xalan2

all: saxon551 saxon6 saxon61 xalan2

saxon551:
	cd saxon551/.classes && make

saxon6:
	cd saxon6/.classes && make

saxon61:
	cd saxon61/.classes && make

xalan2:
	cd xalan2/.classes && make

jars: saxon551 saxon6 saxon61 xalan2
	cd saxon551/.classes && make jar
	cd saxon6/.classes && make jar
	cd saxon61/.classes && make jar
	cd xalan2/.classes && make jar

clean:
	cd saxon551/.classes && make clean
	cd saxon6/.classes && make clean
	cd saxon61/.classes && make clean
	cd xalan2/.classes && make clean
