/****************************************************************************
 * wb_dma_rand_single_transfer_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_rand_single_transfer_seq
 * 
 * Simple random sequence for driving DMA transfers
 */
class wb_dma_rand_single_transfer_seq extends wb_dma_transfer_seq;
	`uvm_object_utils(wb_dma_rand_single_transfer_seq)


	/**
	 * Task: body
	 *
	 * Override from class 
	 */
	virtual task body();
		wb_dma_single_transfer_descriptor desc;
	
		repeat (200) begin
			desc = wb_dma_single_transfer_descriptor::type_id::create("desc");
			
			start_item(desc);
			if (!desc.randomize()) begin
				`uvm_fatal(get_name(), "Failed to randomize sequence item");
			end
			finish_item(desc);
		end
	endtask

	
endclass


