/****************************************************************************
 * wb_dma_seqs_pkg.sv
 ****************************************************************************/
`include "uvm_macros.svh"

/**
 * Package: wb_dma_seqs_pkg
 * 
 * TODO: Add package documentation
 */
package wb_dma_seqs_pkg;
	import uvm_pkg::*;
	import wb_dma_regs_pkg::*;
	import wb_dma_env_pkg::*;
	import mem_mgr_pkg::*;

	`include "wb_dma_reg_seq.svh"
	`include "wb_dma_reg_reset_seq.svh"
	`include "wb_dma_single_transfer_descriptor.svh"
	`include "wb_dma_single_short_transfer_descriptor.svh"
	`include "wb_dma_single_medium_transfer_descriptor.svh"
	
	`include "wb_dma_ll_transfer_descriptor.svh"
	
	// Transfer sequences
	`include "wb_dma_transfer_seq.svh"
	`include "wb_dma_rand_single_transfer_seq.svh"
	`include "wb_dma_rand_single_short_transfer_seq.svh"
	`include "wb_dma_rand_single_medium_transfer_seq.svh"
	
	`include "wb_dma_rand_ll_transfer_seq.svh"
	`include "wb_dma_directed_transfer_seq.svh"
	
	`include "wb_dma_multixfer_vseq.svh"
	`include "wb_dma_rand_4par_transfer_seq.svh"
	
	// Config sequences
	`include "wb_dma_config_seq.svh"
	`include "wb_dma_rand_config_seq.svh"
	
endpackage


