/****************************************************************************
 * wb_dma_test_util.cpp
 ****************************************************************************/
#include "wb_dma_test_util.h"
#include "uex.h"
#include "wb_dma_dev.h"

void wb_dma_test_mem2mem(
  uint32_t				channel,
  uint32_t				sz,
  uint32_t				trn_sz) {

  intptr_t src = (intptr_t)uex_ioalloc(sz*trn_sz, 0, 0);
  intptr_t dst = (intptr_t)uex_ioalloc(sz*trn_sz, 0, 0);

  wb_dma_dev_mem2mem(0, channel, src, dst, sz, trn_sz);

  uex_iofree((void *)src);
  uex_iofree((void *)dst);
}

