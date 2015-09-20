.PHONY: clisp/doc
all: clisp/doc
clisp:
	cvs -z3 -d:pserver:anonymous@clisp.cvs.sourceforge.net:/cvsroot/clisp co -P clisp
clisp/doc: clisp
	$(MAKE) -C clisp/doc STYLESHEETS_PATH=$(DOCBOOK_SVN)/xsl/
clean:
	$(MAKE) -C clisp/doc clean
realclean:
	$(RM) -r clisp
