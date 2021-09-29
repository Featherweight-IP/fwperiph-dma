
WB_DMA_SW_TESTS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ifneq (1,$(RULES))

SRC_DIRS += $(WB_DMA_SW_TESTS_DIR)
WB_DMA_SW_TESTS_SRC = $(notdir $(wildcard $(WB_DMA_SW_TESTS_DIR)/*.cpp))

DPI_OBJS_LIBS += libwb_dma_sw_tests.o

else # Rules

libwb_dma_sw_tests.o : $(WB_DMA_SW_TESTS_SRC:.cpp=.o)
	$(Q)$(LD) -r -o $@ $(WB_DMA_SW_TESTS_SRC:.cpp=.o)

endif

