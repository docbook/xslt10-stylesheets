CVSROOT=pserver:anonymous@cvs.wgdd.de:/cvs/private
SUBMODULE=fglrx_man

CVS=cvs
CVSFLAGS=-z3

all: $(SUBMODULE)

$(SUBMODULE):
	$(CVS) -d:$(CVSROOT) $(CVSFLAGS) co $(SUBMODULE)
	(cd ./$(SUBMODULE) && ./autogen.sh && ./configure && $(MAKE))

clean:
	$(RM) -r $(SUBMODULE)
