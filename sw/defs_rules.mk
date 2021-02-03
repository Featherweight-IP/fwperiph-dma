
FW_PERIPH_DMA_SWDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

ifneq (1,$(RULES))

ifeq (,$(findstring $(FW_PERIPH_DMA_SWDIR),$(MKDV_INCLUDED_DEFS)))
MKDV_INCLUDED_DEFS += $(FW_PERIPH_DMA_SWDIR)
ZEPHYR_MODULES += $(FW_PERIPH_DMA_SWDIR)/fw_periph_dma
endif

else # Rules

endif
