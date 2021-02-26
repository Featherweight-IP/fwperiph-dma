MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
SYNTH_DIR:=$(dir $(MKDV_MK))
FWPERIPH_DMA_DIR := $(abspath $(SYNTH_DIR)/../../..)
PACKAGES_DIR ?= $(FWPERIPH_DMA_DIR)/packages
DV_MK := $(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python -m mkdv mkfile)

TOP_MODULE = fwperiph_dma_wb
MKDV_VL_SRCS += $(wildcard $(FWPERIPH_DMA_DIR)/verilog/rtl/*.v)
MKDV_VL_INCDIRS += $(FWPERIPH_DMA_DIR)/verilog/rtl

include $(PACKAGES_DIR)/fwprotocol-defs/verilog/rtl/defs_rules.mk
include $(DV_MK)

RULES := 1

include $(PACKAGES_DIR)/fwprotocol-defs/verilog/rtl/defs_rules.mk
include $(DV_MK)

