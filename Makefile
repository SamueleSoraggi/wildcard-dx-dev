# ─────────────────────────────────────────────────────────────
#  RONT Super Wildcard DX — PVSnesLib project Makefile
#  Requires PVSNESLIB_HOME to be set in your environment.
#  See docs/setup.md for installation instructions.
# ─────────────────────────────────────────────────────────────

.SUFFIXES:

ifeq ($(strip $(PVSNESLIB_HOME)),)
$(error "PVSNESLIB_HOME is not set. See docs/setup.md.")
endif

# ── project settings ──────────────────────────────────────────
TARGET   := $(shell basename $(CURDIR))
BUILD    := build
SOURCES  := src
INCLUDES := include

# ── compiler flags ────────────────────────────────────────────
CFLAGS   := -Wall -O2 -I$(CURDIR)/$(INCLUDES)

# ── collect sources ───────────────────────────────────────────
export VPATH := \
    $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
    $(foreach dir,$(INCLUDES),$(CURDIR)/$(dir))

CFILES  := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
SFILES  := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.asm)))

export LD_FIRST :=
export OFILES   := $(CFILES:.c=.o) $(SFILES:.asm=.o)
export HFILES   :=

include $(PVSNESLIB_HOME)/devkitsnes/snes_rules

# ── convenience targets ───────────────────────────────────────
.PHONY: header clean-header

# Add 512-byte SMC header for Wildcard DX transfer software
header: $(TARGET).sfc
	python3 tools/add_header.py $(TARGET).sfc $(TARGET).smc
	@echo "→ $(TARGET).smc ready for transfer"

clean-header:
	rm -f $(TARGET).smc
