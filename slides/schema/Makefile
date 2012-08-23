SUBDIRS= relaxng xsd

all:
	for d in ${SUBDIRS}; do \
		${MAKE} -C $${d}; \
	done

clean:
	for d in ${SUBDIRS}; do \
		${MAKE} -C $${d} clean; \
	done

maintainer-clean:
	for d in ${SUBDIRS}; do \
		${MAKE} -C $${d} maintainer-clean; \
	done
