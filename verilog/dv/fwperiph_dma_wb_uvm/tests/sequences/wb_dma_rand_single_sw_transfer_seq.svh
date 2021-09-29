/****************************************************************************
 * wb_dma_rand_single_sw_transfer_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_rand_single_sw_transfer_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_rand_single_sw_transfer_seq extends wb_dma_multixfer_sw_seq;
	`uvm_object_utils(wb_dma_rand_single_sw_transfer_seq)

	
	task body();
		
		repeat (16) begin
		wb_dma_single_transfer_descriptor desc = 
			wb_dma_single_short_transfer_descriptor::type_id::create("desc");
	
		start_item(desc);
		
		if (!desc.randomize()) begin
			`uvm_fatal(get_name(), "Failed to randomize descriptor");
		end
		
		finish_item(desc);
		
		$display("--> wait_done");
		wait_done();
		$display("<-- wait_done");
		end
		
	endtask


endclass


