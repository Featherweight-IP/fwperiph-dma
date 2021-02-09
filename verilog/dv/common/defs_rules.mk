
DV_COMMON_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
FWPERIPH_DMA_DIR := $(abspath $(DV_COMMON_DIR)/../../..)
PACKAGES_DIR ?= $(FWPERIPH_DMA_DIR)/packages
DV_MK := $(shell $(PACKAGES_DIR)/python/bin/python -m mkdv mkfile)
MKDV_TOOL ?= icarus


ifneq (1,$(RULES))

MKDV_VL_SRCS += $(wildcard $(FWPERIPH_DMA_DIR)/verilog/rtl/*.v)
MKDV_VL_INCDIRS += $(FWPERIPH_DMA_DIR)/verilog/rtl
MKDV_VL_INCDIRS += $(PACKAGES_DIR)/fwprotocol-defs/src/sv

MKDV_PYTHONPATH += $(DV_COMMON_DIR)/python

include $(FWPERIPH_DMA_DIR)/verilog/dbg/defs_rules.mk

include $(DV_MK)
else # Rules

include $(DV_MK)
endif


