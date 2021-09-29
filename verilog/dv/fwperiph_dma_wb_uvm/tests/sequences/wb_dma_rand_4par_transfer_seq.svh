/****************************************************************************
 * wb_dma_rand_4par_transfer_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_rand_4par_transfer_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_rand_4par_transfer_seq extends wb_dma_multixfer_vseq;
	`uvm_object_utils(wb_dma_rand_4par_transfer_seq)
	
	task body();
		bit[5:0] channels[$];
		
		for (int i=0; i<31; i++) begin
			channels.push_back(i);
		end
		
		repeat (16) begin
			channels.shuffle();
			
			for (int i=0; i<4; i++) begin
				wb_dma_descriptor desc = wb_dma_descriptor::type_id::create("desc");
			
				start_item(desc);
				if (!desc.randomize()) begin
					`uvm_fatal(get_name(), "Failed to randomize descriptor");
				end
				
				desc.channel = channels[i];
				
				finish_item(desc);
			end
			
			// Now, wait for completion
			wait_done();
		end
	endtask

endclass


