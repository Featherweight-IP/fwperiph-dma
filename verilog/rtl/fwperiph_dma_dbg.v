
/****************************************************************************
 * fwperiph_dma_dbg.v
 ****************************************************************************/

  
/**
 * Module: fwperiph_dma_dbg
 * 
 * TODO: Add module documentation
 */
module fwperiph_dma_dbg #(
		parameter ch_count=1
		) (
		input				clock,
		input[31:0]			adr,
		input[31:0]			dat_w,
		input[31:0]			we,
		input[4:0]			ch_sel,
		input				dma_busy,
		input				dma_done_all
		);

`ifdef FWPERIPH_DMA_DBG_MODULE
`FWPERIPH_DMA_DBG_MODULE #(
			.ch_count(ch_count)
		) u_dbg (
			.clock(			clock),
			.adr(			adr),
			.dat_w(			dat_w),
			.we(			we),
			.ch_sel(		ch_sel),
			.dma_busy(		dma_busy),
			.dma_done_all(	dma_done_all)
		);
`endif

endmodule


