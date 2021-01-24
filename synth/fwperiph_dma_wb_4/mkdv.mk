MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
SYNTH_DIR:=$(dir $(MKDV_MK))
FWPERIPH_DMA_DIR := $(abspath $(SYNTH_DIR)/../..)
PACKAGES_DIR ?= $(FWPERIPH_DMA_DIR)/packages
DV_MK := $(shell $(PACKAGES_DIR)/python/bin/python -m mkdv mkfile)

TOP_MODULE = fw_periph_dma_wb
MKDV_VL_SRCS += $(wildcard $(FWPERIPH_DMA_DIR)/verilog/rtl/*.v)
MKDV_VL_INCDIRS += $(FWPERIPH_DMA_DIR)/verilog/rtl

include $(DV_MK)

RULES := 1

include $(DV_MK)

