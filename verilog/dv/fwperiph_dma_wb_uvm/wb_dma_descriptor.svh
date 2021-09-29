/****************************************************************************
 * wb_dma_descriptor.svh
 ****************************************************************************/
 

/**
 * Class: wb_dma_descriptor
 * 
 * DMA transfer descriptor
 */
class wb_dma_descriptor extends uvm_sequence_item;
	`uvm_object_utils(wb_dma_descriptor)

	// DMA channel to use
	rand bit[5:0]				channel; 
	
	// Memory-to-memory (0) or handshake (1) mode
	rand bit					mode;
	
	// Increment the source address after each transfer
	rand bit					inc_src;
	
	// Increment the destination address after each transfer
	rand bit					inc_dst;
	
	// Master interface to use for reads (0/1)
	rand bit					src_sel;
	// Master interface to use for writes (0/1)
	rand bit					dst_sel;

	// Total number of transfers
	rand bit[11:0]				tot_sz;
	
	// Transfer size (1, 2, 4 bytes)
	rand bit[2:0]				trn_sz;
	rand bit[8:0]				chk_sz;
	
	// Source address
	rand bit[31:0]				src_addr;
	// Destination address
	rand bit[31:0]				dst_addr;
	
	// Set to 1 to enable randomizing addresses
	bit							rand_addr;

	constraint trn_sz_c {
		trn_sz inside {1, 2, 4};
	}

	// One address must always increment, since 
	// non-incrementing addresses are intended for
	// device-centric transfers
	constraint addr_incr_c {
		inc_src || inc_dst;
	}
	
	constraint channel_c {
		channel inside {[0:7]};
	}
	
	constraint tot_sz_c {
		tot_sz > 0;
	}
	
	constraint chk_sz_c {
		chk_sz > 0;
	}
	
	constraint rand_addr_c {
		(rand_addr == 0) -> src_addr == 0;
		(rand_addr == 0) -> dst_addr == 0;
	}

endclass

// Two inFact generator class
// -> cfg
// -> cfg_gdescriptor

//class cfg_descriptor;
//	cfg_c cfg;
//	// constraints
//	rand wb_dma_descriptor desc;
//endclass

