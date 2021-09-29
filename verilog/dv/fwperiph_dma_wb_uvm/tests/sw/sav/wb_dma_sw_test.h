#ifndef INCLUDED_WB_DMA_SW_TEST_H
#define INCLUDED_WB_DMA_SW_TEST_H
#include "gtest/gtest.h"
#include "uex.h"
#include <stdio.h>
//#include "../../../../rtl/wb_dma/fw/wb_dma_dev.h"

//extern wb_dma_uex_drv_t wb_dma_drv;

class wb_dma_sw_test : public ::testing::Test {
public:

	wb_dma_sw_test();

	virtual ~wb_dma_sw_test();

	virtual void SetUp();

};
#endif /* INCLUDED_WB_DMA_SW_TEST_H */

