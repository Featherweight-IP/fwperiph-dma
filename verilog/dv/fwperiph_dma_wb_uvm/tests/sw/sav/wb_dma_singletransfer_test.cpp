
#include "wb_dma_sw_test.h"

TEST(wb_dma, singletransfer) {

	wb_dma_uex_drv_single_xfer(
			&wb_dma_drv,
			0,
			0x1000,
			1,
			0x2000,
			1,
			16);

}
