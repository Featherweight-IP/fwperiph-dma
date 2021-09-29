/*
 * wb_dma_sw_test_base.h
 *
 *  Created on: Feb 8, 2019
 *      Author: ballance
 */
#pragma once
#include "gtest/gtest.h"
#include "wb_dma_dev.h"

class wb_dma_sw_test_base : public ::testing::Test {
public:
	wb_dma_sw_test_base();

	virtual ~wb_dma_sw_test_base();

protected:
	virtual void SetUp();

	static void isr(void *ud);

private:
	static wb_dma_dev_t			m_dma;
	static uex_dev_t			*m_devices[];

};

