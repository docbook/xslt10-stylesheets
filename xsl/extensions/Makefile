.PHONY: doc saxon643 saxon644 saxon65 saxon651 xalan2

all: jars

saxon643:
	$(MAKE) -C saxon643/.classes

saxon644: saxon643
	@echo Saxon 6.4.4 is compatible with Saxon 6.4.3

saxon65: saxon643
	@echo Saxon 6.5 is compatible with Saxon 6.4.3

saxon651: saxon643
	@echo Saxon 6.5 is compatible with Saxon 6.4.3

xalan2:
	$(MAKE) -C xalan2/.classes

jars: saxon643 saxon644 xalan2
	$(MAKE) -C saxon643/.classes jar
	cp saxon643.jar saxon644.jar
	cp saxon643.jar saxon65.jar
	cp saxon643.jar saxon651.jar
	$(MAKE) -C xalan2/.classes jar

clean:
	$(MAKE) -C saxon643/.classes clean
	$(MAKE) -C xalan2/.classes clean
