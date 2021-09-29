/*
 * wb_dma_sw_smoke_tests.cpp
 *
 *  Created on: Feb 8, 2019
 *      Author: ballance
 */

#include "wb_dma_sw_smoke_tests.h"

wb_dma_sw_smoke_tests::wb_dma_sw_smoke_tests() {
	// TODO Auto-generated constructor stub

}

wb_dma_sw_smoke_tests::~wb_dma_sw_smoke_tests() {
	// TODO Auto-generated destructor stub
}

TEST_F(wb_dma_sw_smoke_tests,single_m2m) {
	fprintf(stdout, "single_m2m test\n");

	// TODO: Initialize memory first

	// TODO: remember address map
	wb_dma_dev_mem2mem(0,
			1,// channel
			0x00001000,
			0x00002000,
			0x10,
			1);

	uex_iowrite32(0x10, (void *)0x1000);
	int val = uex_ioread32((void *)0x1000);

	fprintf(stdout, "read: 0x%08x\n", val);

	// TODO: check

}

