/****************************************************************************
 * wb_dma_test_util.h
 ****************************************************************************/
#ifndef INCLUDED_WB_DMA_TEST_UTIL_H
#define INCLUDED_WB_DMA_TEST_UTIL_H
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

void wb_dma_test_mem2mem(
  uint32_t				channel,
  uint32_t				sz,
  uint32_t				trn_sz);

#ifdef __cplusplus
}
#endif
#endif /* INCLUDED_WB_DMA_TEST_UTIL_H */

