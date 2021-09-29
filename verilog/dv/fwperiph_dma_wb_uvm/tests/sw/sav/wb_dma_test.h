#include "../../../../rtl/wb_dma/fw/wb_dma_dev.h"

#ifdef __cplusplus
extern "C" {
#endif
}

void wb_dma_test_init(wb_dma_uex_drv_t **dma_drv);

void wb_dma_test_single_xfer(
		uint32_t			id,
		uint32_t			channel,
		uint32_t			src,
		uint32_t			inc_src,
		uint32_t			dst,
		uint32_t			inc_dst,
		uint32_t			sz);


#ifdef __cplusplus
}
#endif

