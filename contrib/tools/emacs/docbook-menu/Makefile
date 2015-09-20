VERSION     := $(shell cat VERSION)
DIRNAME     := $(notdir $(shell pwd))
CHANGELOG    = ChangeLog
EXCLUDE_FILE = exclude.txt
LISP_FILES  := $(shell find . -name "*.el" -print)
BYTE_FILES  := $(shell find . -name "*.elc" -print)
ALL_FILES   = $(shell find . -type f -print)

# ssh and scp are needed for updating files on remote host
SSH           = ssh
SSH_OPTS      =
SCP           = scp
SCP_OPTS      = -pr

NCFTPPUT      = ncftpput
NCFTPPUT_OPTS =

REMOTEHOST    = upload.sourceforge.net
REMOTEDIR     = /incoming

MAKE         = make
EMACS        = emacs
FMT          = fmt
RCS2LOG      = rcs2log
RCS2LOG_OPTS = -h sideshowbarker.net
ZIP          = zip
ZIP_OPTS    := -r $(DIRNAME)-$(VERSION).zip $(DIRNAME) -x@$(DIRNAME)/$(EXCLUDE_FILE)

DOCS_DIR     = doc

.PHONY: changelog $(DOCS_DIR)

all:	byte-compile changelog $(DOCS_DIR) set-perms dist

set-perms: $(ALL_FILES)
	@echo
	@echo "Fixing file permissions..."
	chmod 664 $^

byte-compile: $(LISP_FILES)
	@echo
	@echo "Byte compiling lisp files..."
	$(EMACS) -batch -f batch-byte-compile $^

changelog:
	@echo
	@echo "Writing $(CHANGELOG) file..."
	$(RCS2LOG) $(RCS2LOG_OPTS) | $(FMT) > $(CHANGELOG)

$(DOCS_DIR):
	@echo
	@echo "Making docs..."
	$(MAKE) -C $(DOCS_DIR)

dist:
	@echo
	@echo "Creating $(DIRNAME)-$(VERSION).zip file..."
	-rm $(DIRNAME)*.zip;
	(cd ..; \
	$(ZIP) $(ZIP_OPTS) ;\
	mv $(DIRNAME)-$(VERSION).zip $(DIRNAME) )

install:
	$(NCFTPPUT) $(NCFTPPUT_OPTS) $(REMOTEHOST) $(REMOTEDIR) $(DIRNAME)-$(VERSION).zip

clean: $(BYTE_FILES)
	-rm $^
	-rm $(DIRNAME)-$(VERSION).zip
	-$(MAKE) -C $(DOCS_DIR) clean

debug:
	echo "$(DIRNAME)"
