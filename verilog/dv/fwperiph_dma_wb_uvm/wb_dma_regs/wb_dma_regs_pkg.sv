/****************************************************************************
 * wb_dma_regs_pkg.sv
 ****************************************************************************/
`include "uvm_macros.svh"

/**
 * Package: wb_dma_regs_pkg
 * 
 * TODO: Add package documentation
 */
package wb_dma_regs_pkg;
	import uvm_pkg::*;

	`include "wb_dma_csr.svh"
	`include "wb_dma_int_msk.svh"
	`include "wb_dma_int_src.svh"
	`include "wb_dma_ch_csr.svh"
	`include "wb_dma_ch_sz.svh"
	`include "wb_dma_ch_adr.svh"	
	`include "wb_dma_ch_adr_mask.svh"	
	`include "wb_dma_ch.svh"	
	`include "wb_dma_reg_block.svh"
	


endpackage


