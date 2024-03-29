#****************************************************************************
#* MKDV makefile fragement for fwperiph_dma
#* 
#* Adds sources required to use the fwperiph_dma RTL
#****************************************************************************
FWPERIPH_DMA_DBGDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

ifneq (1,$(RULES))

ifeq (,$(findstring $(FWPERIPH_DMA_DBGDIR), $(MKDV_INCLUDED_DEFS)))
MKDV_INCLUDED_DEFS += $(FWPERIPH_DMA_DBGDIR)
MKDV_VL_INCDIRS += $(FWPERIPH_DMA_DBGDIR)

MKDV_VL_SRCS += $(wildcard $(FWPERIPH_DMA_DBGDIR)/*.v)

# Enable BFM instantiation in the debug-module socket
MKDV_VL_DEFINES += FWPERIPH_DMA_DBG_MODULE=fwperiph_dma_dbg_bfm

# Ensure that the Python BFM is included
MKDV_PYTHONPATH += $(FWPERIPH_DMA_DBGDIR)/python
MKDV_PLUGINS += pybfms
PYBFMS_MODULES += fwperiph_dma_bfms
endif

else # Rules

endif
