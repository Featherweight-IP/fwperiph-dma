/****************************************************************************
 * wb_dma_single_transfer_descriptor_cov.svh
 ****************************************************************************/

/**
 * Class: wb_dma_single_transfer_descriptor_cov
 * 
 * Coverage monitor for single-transfer DMA sequence items
 */
class wb_dma_single_transfer_descriptor_cov extends uvm_subscriber #(wb_dma_descriptor);
	`uvm_component_utils(wb_dma_single_transfer_descriptor_cov)
	
	wb_dma_descriptor			desc;
	
	covergroup single_desc_cg;
		
		channel_cp : coverpoint desc.channel {
			bins channels[] = {[0:7]};
		}
		
		tot_sz_cp : coverpoint desc.tot_sz {
			bins small_xfer[] = {[1:16]};
			bins med_xfer[16] = {[16:4089]};
			bins huge_xfer[] = {[4090:4095]};
		}
		
		trn_sz_cp : coverpoint desc.trn_sz {
			bins trn_sz[] = {1, 2, 4};
		}
		
		chk_sz_cp : coverpoint desc.chk_sz {
			bins small_chk[] = {[1:15]};
		}
		
		chk_tot_sz_cross : cross tot_sz_cp, chk_sz_cp;
		
		tot_trn_sz_cross : cross tot_sz_cp, trn_sz_cp;
		
		src_cp     : coverpoint desc.src_sel;
		dst_cp     : coverpoint desc.dst_sel;
		inc_src_cp : coverpoint desc.inc_src;
		inc_dst_cp : coverpoint desc.inc_dst;
		
		src_dst_inc_cross : cross src_cp, dst_cp, inc_src_cp, inc_dst_cp {
			ignore_bins unreachable = 
				binsof(inc_src_cp) intersect {0} && 
				binsof(inc_dst_cp) intersect {0}
			;
		}
		
	endgroup
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
		single_desc_cg = new();
	endfunction

	/**
	 * Function: write
	 *
	 * Override from class 
	 */
	virtual function void write(input T t);
		wb_dma_ll_descriptor ll_desc;
		
		desc = t;
		if (!$cast(ll_desc, desc)) begin
			single_desc_cg.sample();
		end
	endfunction

endclass


