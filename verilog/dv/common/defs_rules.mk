
DV_COMMON_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
FWPERIPH_DMA_DIR := $(abspath $(DV_COMMON_DIR)/../../..)
PACKAGES_DIR ?= $(FWPERIPH_DMA_DIR)/packages
DV_MK := $(shell $(PACKAGES_DIR)/python/bin/python -m mkdv mkfile)
MKDV_TOOL ?= icarus


ifneq (1,$(RULES))

MKDV_PYTHONPATH += $(DV_COMMON_DIR)/python

include $(FWPERIPH_DMA_DIR)/verilog/rtl/defs_rules.mk
include $(FWPERIPH_DMA_DIR)/verilog/dbg/defs_rules.mk

include $(DV_MK)
else # Rules

include $(DV_MK)
endif


