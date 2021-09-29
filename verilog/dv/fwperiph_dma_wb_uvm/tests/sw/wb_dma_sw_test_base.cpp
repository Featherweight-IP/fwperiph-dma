/*
 * wb_dma_sw_test_base.cpp
 *
 *  Created on: Feb 8, 2019
 *      Author: ballance
 */

#include "wb_dma_sw_test_base.h"
#include <stdio.h>

wb_dma_sw_test_base::wb_dma_sw_test_base() {
	// TODO Auto-generated constructor stub

}

wb_dma_sw_test_base::~wb_dma_sw_test_base() {
	// TODO Auto-generated destructor stub
}

void wb_dma_sw_test_base::SetUp() {
	m_dma.base.name = "dma";
	m_dma.base.addr = 0x00000000;
	m_dma.base.init = &wb_dma_dev_init;

	uex_init(m_devices, 1);

	// Hook up interrupts
	uex_set_irq_handler(&wb_dma_sw_test_base::isr, 0);
}

void wb_dma_sw_test_base::isr(void *ud) {
	fprintf(stdout, "--> uex_trigger_irq\n");
	uex_trigger_irq(0); // Send to the DMA
	fprintf(stdout, "<-- uex_trigger_irq\n");
}

// Device table
wb_dma_dev_t wb_dma_sw_test_base::m_dma; // = WB_DMA_DEV_STATIC_INIT("dma", 0x00000000);
uex_dev_t *wb_dma_sw_test_base::m_devices[] = {
		&wb_dma_sw_test_base::m_dma.base
};

/****************************************************************************
 * wb_dma_sw_test_run()
 *
 * DPI function called from UVM to run a SW Test
 ****************************************************************************/
extern "C" int wb_dma_sw_test_run(
		const char		*gtest_filter,
		int unsigned	*pass) {
	int argc = 0;
	char **argv = 0;
	int status;

	testing::InitGoogleTest(&argc, argv);

	::testing::GTEST_FLAG(filter) = gtest_filter;

	status = RUN_ALL_TESTS();

	// TODO: determine if tests passed
	*pass = 1;

	return 0;
}

