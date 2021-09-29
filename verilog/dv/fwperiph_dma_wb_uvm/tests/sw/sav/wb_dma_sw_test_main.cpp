
#include "wb_dma_sw_test.h"
#include <string.h>

extern "C" int wb_dma_sw_test_main(const char *test, int *status);

wb_dma_uex_drv_t			wb_dma_drv;

static void irq_handler(void *ud) {
	uex_trigger_irq(0);
}


int wb_dma_sw_test_main(
		const char *test,
		int 		*status) {
	int argc = 2;
	char arg0[16];
	char arg1[256];
	char *argv[2];

	strcpy(arg0, "swtest");
	sprintf(arg1, "--gtest_filter=%s", test);

	argv[0] = arg0;
	argv[1] = arg1;

	testing::InitGoogleTest(&argc, argv);

	// Initialize the SW environment
	uex_sv_set_interrupt_handler(&irq_handler, 0);
	uex_set_irq_id((uint32_t *)0x0000, 1);

	wb_dma_uex_drv_init(&wb_dma_drv, 0, 0);

	*status = RUN_ALL_TESTS();

	UnitTest *ut = UnitTest::GetInstance();

	if (ut->total_test_case_count() == 0) {
		*status = 0;
	} else {
		*status = (ut->Passed())?1:0
	}

	return 0;
}
