#****************************************************************************
#* MKDV makefile fragement for fwperiph_dma
#* 
#* Adds sources required to use the fwperiph_dma RTL
#****************************************************************************
FWPERIPH_DMA_RTLDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

ifneq (1,$(RULES))

ifeq (,$(findstring $(FWPERIPH_DMA_RTLDIR), $(MKDV_INCLUDED_DEFS)))
MKDV_INCLUDED_DEFS += $(FWPERIPH_DMA_RTLDIR)
MKDV_VL_INCDIRS += $(FWPERIPH_DMA_RTLDIR)
MKDV_VL_SRCS += $(wildcard $(FWPERIPH_DMA_RTLDIR)/*.v)

MKDV_VL_BB_SRCS += $(FWPERIPH_DMA_RTLDIR)/fwperiph_dma_dbg.v

include $(PACKAGES_DIR)/fwprotocol-defs/verilog/rtl/defs_rules.mk
endif # !INCLUDED

else # Rules

endif
