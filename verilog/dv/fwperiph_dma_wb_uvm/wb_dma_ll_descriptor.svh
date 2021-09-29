/****************************************************************************
 * wb_dma_ll_descriptor.svh
 ****************************************************************************/

class wb_dma_ll_desc_item extends uvm_object;
	`uvm_object_utils(wb_dma_ll_desc_item)
	
	
	rand bit		inc_src;
	rand bit		inc_dst;
	rand bit		src_sel;
	rand bit		dst_sel;
	
	bit[31:0]		src_addr;
	bit[31:0]		dst_addr;
	
	rand bit[11:0]	tot_sz;
	
	bit[31:0]		desc;
	
	constraint tot_sz_c {
		tot_sz > 0;
	}
	
endclass


/**
 * Class: wb_dma_ll_descriptor
 * 
 * TODO: Add class documentation
 */
class wb_dma_ll_descriptor extends wb_dma_descriptor;
	`uvm_object_utils(wb_dma_ll_descriptor)

	rand wb_dma_ll_desc_item	ll_desc[16];
	rand bit[15:0]				ll_desc_sz;
	
	// Total size of a linked-list transfer
	rand bit[31:0]				ll_desc_tot_sz[16];
	
	function new(string name="wb_dma_ll_descriptor");
		foreach (ll_desc[i]) begin
			ll_desc[i] = wb_dma_ll_desc_item::type_id::create("");
		end
	endfunction
	
	constraint ll_desc_sz_c {
		ll_desc_sz inside {[1:16]};
	}


endclass


