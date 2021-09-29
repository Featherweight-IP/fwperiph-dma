#include "wb_dma_test.h"

static wb_dma_uex_drv_t			**prv_dma_drv = 0;

void wb_dma_test_init(wb_dma_uex_drv_t **dma_drv) {
	prv_dma_drv = dma_drv;
}

void wb_dma_test_single_xfer(
		uint32_t			id,
		uint32_t			channel,
		uint32_t			src,
		uint32_t			inc_src,
		uint32_t			dst,
		uint32_t			inc_dst,
		uint32_t			sz) {
	wb_dma_uex_drv_single_xfer(prv_dma_drv[id], channel,
			src, inc_src, dst, inc_dst, sz);
}

