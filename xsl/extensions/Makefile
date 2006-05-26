ANT = ant
ANT_OPTS =

all: jars

jars: saxon65.jar xalan2.jar xalan27.jar

saxon65.jar: $(wildcard saxon65/src/com/nwalsh/saxon/*.java)
	cd saxon65 && $(ANT) jar
	cp saxon65/dist/saxon65.jar .

xalan2.jar: $(wildcard xalan2/src/com/nwalsh/xalan/*.java)
	cd xalan2 && $(ANT) jar
	cp xalan2/dist/xalan2.jar .

xalan27.jar: $(wildcard xalan27/src/com/nwalsh/xalan/*.java)
	cd xalan27 && $(ANT) jar
	cp xalan27/dist/xalan27.jar .

clean:
	cd saxon65 && $(ANT) clean
	cd xalan27 && $(ANT) clean
	$(RM) *.jar
