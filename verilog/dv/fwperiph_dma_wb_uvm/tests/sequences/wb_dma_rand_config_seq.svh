/****************************************************************************
 * wb_dma_rand_config_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_rand_config_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_rand_config_seq extends wb_dma_config_seq;
	`uvm_object_utils(wb_dma_rand_config_seq)
	
	virtual task body();
		wb_dma_config cfg = wb_dma_config::type_id::create("cfg");
	
		start_item(cfg);
		
		if (!cfg.randomize()) begin
			`uvm_fatal(get_name(), "Failed to randomize config");
		end
		
		finish_item(cfg);
	endtask

endclass


