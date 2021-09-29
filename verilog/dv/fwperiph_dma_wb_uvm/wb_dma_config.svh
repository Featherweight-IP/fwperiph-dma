/****************************************************************************
 * wb_dma_config.svh
 ****************************************************************************/

/**
 * Class: wb_dma_config
 * 
 * TODO: Add class documentation
 */
class wb_dma_config extends uvm_sequence_item;
	`uvm_object_utils(wb_dma_config)
	
	// Channel priorities
	rand bit[2:0]			channel_pri[31];
	
	// Interrupt masking
	rand bit[31:0]			int_msk_a;
	
	rand bit[31:0]			int_msk_b;
	
	constraint int_msk_c {
		// An interrupt must be enabled for each channel
		int_msk_a | int_msk_b == 'h7fff_ffff;
	}
	

endclass


