
#include "wb_dma_sw_test.h"
#include "wb_dma_test.h"
#include "dma_parallel_xfer_scenario_100.c"

TEST(wb_dma, pss_parallel_xfer) {
    wb_dma_uex_drv_t *drv_l[] = {&wb_dma_drv};

    wb_dma_test_init(drv_l);

    dma_parallel_xfer_scenario_100();

}
