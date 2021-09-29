/****************************************************************************
 * wb_dma_descriptor_raddr.svh
 * 
 * 
 ****************************************************************************/
 

/**
 * Class: wb_dma_descriptor
 * 
 * DMA transfer descriptor
 */
class wb_dma_descriptor_raddr extends wb_dma_descriptor;
	`uvm_object_utils(wb_dma_descriptor_raddr)

	// 
	function void pre_randomize();
		rand_addr = 1;
	endfunction
	
endclass


