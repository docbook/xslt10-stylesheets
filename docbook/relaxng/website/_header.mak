# -*- Makefile -*-

_MAKEFILES := $(filter-out _header.mak _footer.mak,$(MAKEFILE_LIST))

_MODULE := $(patsubst %/,%,$(dir $(word $(words $(_MAKEFILES)),$(_MAKEFILES))))

$(_MODULE)_OUTPUT := $(_OUTTOP)/$(_MODULE)

$($(_MODULE)_OUTPUT)/.f:
	@if !([ -e $@ ]); then \
		( mkdir -p $(patsubst %/.f,%,$@) ; \
		  touch $@ ); fi
