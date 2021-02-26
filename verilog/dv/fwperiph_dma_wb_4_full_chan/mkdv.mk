
MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR := $(dir $(MKDV_MK))
DV_COMMON_DIR := $(abspath $(TEST_DIR)/../common)

MKDV_PLUGINS += pybfms cocotb

PYBFMS_MODULES += wishbone_bfms event_bfms

TOP_MODULE = fwperiph_dma_wb_4_full_chan_tb
MKDV_TEST ?= regtest
MKDV_COCOTB_MODULE = fwperiph_dma_tests.$(MKDV_TEST)

MKDV_VL_SRCS += $(TEST_DIR)/fwperiph_dma_wb_4_full_chan_tb.sv

include $(DV_COMMON_DIR)/defs_rules.mk

RULES := 1

include $(DV_COMMON_DIR)/defs_rules.mk

