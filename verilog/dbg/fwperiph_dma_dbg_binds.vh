/*****************************************************************************
 *****************************************************************************/
 
`ifdef HAVE_BIND
// TODO: Bind debug module	
`else
// TODO: Define macro
`define BINDINST_FWPERIPH_DMA_DBG(ID,CH_COUNT, PATH) \
	wire               dma_dbg_bfm_``ID``_clock       = PATH .u_dbg.clock; \
	wire[8:0]          dma_dbg_bfm_``ID``_adr         = PATH .u_dbg.adr; \
	wire[31:0]         dma_dbg_bfm_``ID``_dat_w       = PATH .u_dbg.dat_w; \
	wire               dma_dbg_bfm_``ID``_we          = PATH .u_dbg.we; \
	fwperiph_dma_dbg_bfm #( \
		.ch_count(CH_COUNT) \
	) dma_dbg_bfm_``ID ( \
		.clock(dma_dbg_bfm_``ID``_clock), \
		.adr(dma_dbg_bfm_``ID``_adr), \
		.dat_w(dma_dbg_bfm_``ID``_dat_w), \
		.we(dma_dbg_bfm_``ID``_we) \
	)
`define BINDTYPE_FWPERIPH_DMA_DBG \
	`error Attempt to use type binding without support
`endif