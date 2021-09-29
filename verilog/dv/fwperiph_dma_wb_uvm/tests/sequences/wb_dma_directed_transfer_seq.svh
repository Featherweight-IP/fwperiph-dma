/****************************************************************************
 * wb_dma_directed_transfer_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_directed_transfer_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_directed_transfer_seq extends wb_dma_transfer_seq;
	`uvm_object_utils (wb_dma_directed_transfer_seq)
	
	wb_dma_descriptor			desc;

	task body();
		start_item(desc);
		finish_item(desc);
	endtask

endclass


