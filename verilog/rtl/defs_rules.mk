#****************************************************************************
#* MKDV makefile fragement for fwperiph_dma
#* 
#* Adds sources required to use the fwperiph_dma RTL
#****************************************************************************
FWPERIPH_DMA_RTL_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

ifneq (1,$(RULES))

MKDV_VL_INCDIRS += $(FWPERIPH_DMA_RTL_DIR)
MKDV_VL_SRCS += $(wildcard $(FWPERIPH_DMA_RTL_DIR)/*.v)

else # Rules

endif
