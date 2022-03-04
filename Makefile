# This Makefile assumes the top folder has been built

CONCORD = ..
CC ?= gcc

COGUTILS_DIR := $(TOP)/cog-utils
CORE_DIR     := $(TOP)/core
INCLUDE_DIR  := $(TOP)/include
GENCODECS_DIR  := $(TOP)/gencodecs

BOTS := ping-pong \
        # audit-log \
        # ban \
        # channel \
        # components \
        # copycat \
        # embed \
        # emoji \
        # fetch-messages \
        # guild-template \
        # guild \
        # invite \
        # manual-dm \
        # pin \
        # presence \
        # reaction \
        # shell \
        # slash-commands \
        # slash-commands2 \
        # spam \
        # webhook \
        $(XSRC)

CFLAGS  += -I$(INCLUDE_DIR) -I$(COGUTILS_DIR) -I$(CORE_DIR) \
           -I$(CORE_DIR)/third-party -I$(GENCODECS_DIR)     \
           -O0 -g -pthread -Wall $(XFLAGS)
LDFLAGS += -L$(TOP)/lib $(pkg-config --libs --cflags libcurl) -lcurl

all: $(BOTS)

voice:
	$(MAKE) XFLAGS=-DHAS_DISCORD_VOICE XSRC=voice all

$(BOTS): %: %.c
	$(CC) $(CFLAGS) -o $@ $< -ldiscord $(LDFLAGS)

echo:
	@ echo -e 'CC: $(CC)\n'
	@ echo -e 'BOTS: $(BOTS)\n'

clean:
	rm -rf $(BOTS)

.PHONY: all echo clean
