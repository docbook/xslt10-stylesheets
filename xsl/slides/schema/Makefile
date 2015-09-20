subdirs:=relaxng xsd

all:
	for d in $(subdirs); do \
		$(MAKE) -C $$d; \
	done

clean:
	for d in $(subdirs); do \
		$(MAKE) -C $$d clean; \
	done

maintainer-clean:
	for d in $(subdirs); do \
		$(MAKE) -C $$d maintainer-clean; \
	done
