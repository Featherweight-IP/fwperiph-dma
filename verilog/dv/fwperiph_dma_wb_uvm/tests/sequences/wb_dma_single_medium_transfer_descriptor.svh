/****************************************************************************
 * wb_dma_single_transfer_descriptor.svh
 ****************************************************************************/

/**
 * Class: wb_dma_single_medium_transfer_descriptor
 * 
 * TODO: Add class documentation
 */
class wb_dma_single_medium_transfer_descriptor extends wb_dma_single_transfer_descriptor;
	`uvm_object_utils(wb_dma_single_medium_transfer_descriptor)

	// disable linked-list transfers
	constraint small_size_c {
		chk_sz <= 256;
	}

endclass


