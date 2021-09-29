MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR:=$(dir $(MKDV_MK))
MKDV_TOOL ?= questa

VLOG_OPTIONS += -sv

#********************************************************************
#* BFMs
#********************************************************************
MKDV_VL_INCDIRS += $(TEST_DIR)/bfms/api
MKDV_VL_INCDIRS += $(TEST_DIR)/bfms/event/uvm
MKDV_VL_INCDIRS += $(TEST_DIR)/bfms/wb/uvm

MKDV_VL_SRCS += $(TEST_DIR)/bfms/api/sv_bfms_api_pkg.sv
MKDV_VL_SRCS += $(TEST_DIR)/bfms/event/event_api_pkg.sv
MKDV_VL_SRCS += $(TEST_DIR)/bfms/event/event_bfm.sv
MKDV_VL_SRCS += $(TEST_DIR)/bfms/event/uvm/event_agent_pkg.sv

MKDV_VL_SRCS += $(TEST_DIR)/bfms/wb/wb_master_api_pkg.sv
MKDV_VL_SRCS += $(TEST_DIR)/bfms/wb/uvm/wb_master_agent_pkg.sv
MKDV_VL_SRCS += $(TEST_DIR)/bfms/wb/wb_master_bfm.sv

MKDV_VL_SRCS += $(TEST_DIR)/bfms/wb/wb_slave_api_pkg.sv
MKDV_VL_SRCS += $(TEST_DIR)/bfms/wb/uvm/wb_slave_agent_pkg.sv
MKDV_VL_SRCS += $(TEST_DIR)/bfms/wb/wb_slave_bfm.sv

MKDV_VL_SRCS += $(TEST_DIR)/wb_if.sv

#********************************************************************
#* Register Model
#********************************************************************
MKDV_VL_INCDIRS += $(TEST_DIR)/wb_dma_regs
MKDV_VL_SRCS += $(TEST_DIR)/wb_dma_regs/wb_dma_regs_pkg.sv

#********************************************************************
#* Mem-mgr
#********************************************************************
MKDV_VL_INCDIRS += $(TEST_DIR)/mem_mgr
MKDV_VL_SRCS += $(TEST_DIR)/mem_mgr/mem_mgr_pkg.sv

#********************************************************************
#* Env
#********************************************************************
MKDV_VL_INCDIRS += $(TEST_DIR)
MKDV_VL_SRCS += $(TEST_DIR)/wb_dma_env_pkg.sv


MKDV_VL_INCDIRS += $(TEST_DIR)/tests
MKDV_VL_INCDIRS += $(TEST_DIR)/tests/sequences
MKDV_VL_INCDIRS += $(TEST_DIR)/tests/coverage

MKDV_VL_SRCS += $(TEST_DIR)/tests/sequences/wb_dma_seqs_pkg.sv
MKDV_VL_SRCS += $(TEST_DIR)/tests/coverage/wb_dma_coverage_pkg.sv
MKDV_VL_SRCS += $(TEST_DIR)/tests/wb_dma_tests_pkg.sv


MKDV_VL_SRCS += $(TEST_DIR)/fwperiph_dma_wb_uvm_tb.sv
TOP_MODULE = fwperiph_dma_wb_uvm_tb


include $(TEST_DIR)/../common/defs_rules.mk
RULES := 1
include $(TEST_DIR)/../common/defs_rules.mk

