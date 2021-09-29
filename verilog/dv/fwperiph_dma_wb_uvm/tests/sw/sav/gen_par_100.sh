#!/bin/sh

infactpss generate flat-c \
  ../pss2/dma_single_xfer_scenario.pss \
  -component dma_single_xfer_scenario_c \
  -action dma_single_xfer_scenario_a \
  -o dma_parallel_xfer_scenario_100.c

