MKDV_MK:=$(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR:=$(dir $(MKDV_MK))
PACKAGES_DIR:=$(abspath $(TEST_DIR)/../../../packages)
MKDV_TOOL ?= questa

TBLINK_RPC_FILES := $(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python -m tblink_rpc_hdl files sv-uvm)
TBLINK_RPC_DPI := $(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python -m tblink_rpc_hdl simplugin)
ZEPHYR_COSIM_FILES := $(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python -m zephyr_cosim sv-files)
SOC_ROOT:=$(shell PATH=$(PACKAGES_DIR)/python/bin:$(PATH) python -m zephyr_cosim soc-root)

VLOG_OPTIONS += -sv

DPI_LIBS += $(TBLINK_RPC_DPI)

MKDV_RUN_ARGS += +UVM_TESTNAME=wb_dma_sw_driver_test
MKDV_RUN_ARGS += +zephyr-cosim-exe=$(MKDV_CACHEDIR)/sw_tests/zephyr/zephyr.exe

MKDV_BUILD_DEPS += $(MKDV_CACHEDIR)/sw_tests.d

#********************************************************************
#* Zephyr-Cosim
#********************************************************************
MKDV_VL_SRCS += $(TBLINK_RPC_FILES)
MKDV_VL_INCDIRS += $(sort $(dir $(TBLINK_RPC_FILES)))
MKDV_VL_SRCS += $(ZEPHYR_COSIM_FILES)


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

#********************************************************************
#* Rules
#********************************************************************
RULES := 1

SW_TESTS_DEPS := $(shell find $(TEST_DIR)/sw_tests -type f)

$(MKDV_CACHEDIR)/sw_tests.d : $(SW_TESTS_DEPS)
	$(Q)rm -rf $(MKDV_CACHEDIR)/sw_tests
	$(Q)mkdir -p $(MKDV_CACHEDIR)/sw_tests
	$(Q)cd $(MKDV_CACHEDIR)/sw_tests ; \
		PACKAGES_DIR=$(PACKAGES_DIR) \
		ZEPHYR_BASE=$(PACKAGES_DIR)/zephyr \
		cmake $(TEST_DIR)/sw_tests \
                -DZEPHYR_BASE=$(PACKAGES_DIR)/zephyr \
                -DSOC_ROOT=$(SOC_ROOT) \
                -DBOARD_ROOT=$(TEST_DIR)/zephyr \
                -DBOARD=fwperiph_dma_64
	$(Q) PATH=$(PACKAGES_DIR)/python/bin:$(PATH) \
                $(MAKE) -C $(MKDV_CACHEDIR)/sw_tests || rm -rf $@
	$(Q)touch $@

include $(TEST_DIR)/../common/defs_rules.mk


