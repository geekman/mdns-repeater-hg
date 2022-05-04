# Makefile for mdns-repeater


ZIP_NAME = mdns-repeater-$(VERSION)

ZIP_FILES = mdns-repeater	\
			README.txt		\
			LICENSE.txt

VERSION=2011-09-21

CFLAGS=-Wall

ifeq ($(OS),Windows_NT) 
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif


ifdef DEBUG
	CFLAGS+= -g
else
	CFLAGS+= -Os
endif

ifeq ($(detected_OS), Darwin)
	CFLAGS+= -DSOL_IP=IPPROTO_IP
else	
	LDFLAGS+= -s
endif

CFLAGS+= -DVERSION="\"${VERSION}\""

.PHONY: all clean

all: mdns-repeater

mdns-repeater.o: _version

mdns-repeater: mdns-repeater.o

.PHONY: zip
zip: TMPDIR := $(shell mktemp -d)
zip: mdns-repeater
	mkdir $(TMPDIR)/$(ZIP_NAME)
	cp $(ZIP_FILES) $(TMPDIR)/$(ZIP_NAME)
	-$(RM) $(CURDIR)/$(ZIP_NAME).zip
	cd $(TMPDIR) && zip -r $(CURDIR)/$(ZIP_NAME).zip $(ZIP_NAME)
	-$(RM) -rf $(TMPDIR)

# version checking rules
.PHONY: dummy
_version: dummy
	@echo $(VERSION) | cmp -s $@ - || echo $(VERSION) > $@

clean:
	-$(RM) *.o
	-$(RM) _version
	-$(RM) mdns-repeater
	-$(RM) mdns-repeater-*.zip

