/****************************************************************************
 * wb_dma_multixfer_sw_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_multixfer_sw_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_multixfer_sw_seq extends wb_dma_transfer_seq;
	`uvm_object_utils(wb_dma_multixfer_sw_seq)
	
	bit[31:0]							m_active_channels;
	wb_dma_drv_t						m_drv_id;
	wb_dma_descriptor					m_active_descs[31];
	

	function new(string name="wb_dma_multxfer_sw_seq");
		super.new(name);
	endfunction
	
	/**
	 * Task: finish_item
	 *
	 * Override from class 
	 */
	virtual task finish_item(
		input uvm_sequence_item item, 
		input int set_priority=-1);	
		wb_dma_descriptor 		desc;
		wb_dma_ll_descriptor 	ll_desc;
		wb_dma_directed_transfer_seq seq = wb_dma_directed_transfer_seq::type_id::create("seq");

		if (!$cast(desc, item)) begin
			`uvm_fatal(get_name(), "Failed to cast item to wb_dma_descriptor");
		end
		
		m_active_descs[desc.channel] = desc;
	
		if ($cast(ll_desc, desc)) begin
			// LL transfer
			setup_ll_transfer(ll_desc);
		end else begin
			// Single transfer
			setup_single_transfer(desc);
		end
		
		m_active_channels[desc.channel] = 1;
		
	endtask
	
	task setup_single_transfer(wb_dma_descriptor desc);
		m_mem_mgr.malloc(
			desc.src_addr,
			desc.tot_sz*4,
			"Source");
		
		// Write non-zero data 
		for (int i=0; i<desc.tot_sz; i++) begin
			bit[31:0] data = (i+1);
			
			m_mem_mgr.direct_access(
					desc.src_addr+(4*i),
					1,
					data);
		end
		
		m_mem_mgr.malloc(
				desc.dst_addr,
				desc.tot_sz*4,
				"Source");		
	
		wb_dma_init_single_xfer(m_drv_id, 
				desc.channel,
				desc.src_addr,
				desc.inc_src,
				desc.dst_addr,
				desc.inc_dst,
				desc.tot_sz);
	endtask
	
	task setup_ll_transfer(wb_dma_ll_descriptor desc);
		// Allocate space for the initial descriptor
		m_mem_mgr.malloc(
				desc.ll_desc[0].desc,
				4*4,
				"LL Desc",
				16);
		
		for (int i=0; i<desc.ll_desc_sz; i++) begin
			
			m_mem_mgr.malloc(
					desc.ll_desc[i].src_addr,
					desc.ll_desc[i].tot_sz*4,
					"LL Src");
			
			// Write non-zero data 
			for (int j=0; j<desc.ll_desc[i].tot_sz; j++) begin
				m_mem_mgr.write32(
						desc.ll_desc[i].src_addr+(4*j), j+1);
			end			
			
			m_mem_mgr.malloc(
					desc.ll_desc[i].dst_addr,
					desc.ll_desc[i].tot_sz*4,
					"LL Dst");
			
			if (i+1<desc.ll_desc_sz) begin
				// Allocate next descriptor if there will be one
				m_mem_mgr.malloc(
					desc.ll_desc[i+1].desc,
					4*4,
					"LL Desc",
					16);
			end
		
			wb_dma_init_linklist_desc(m_drv_id, 
					desc.ll_desc[i].src_addr, 
					desc.ll_desc[i].inc_src, 
					desc.ll_desc[i].dst_addr, 
					desc.ll_desc[i].inc_dst, 
					desc.ll_desc[i].tot_sz, 
					desc.ll_desc[i].desc, 
					(i+1<desc.ll_desc_sz)?desc.ll_desc[i+1].desc:0);
		end
		
		wb_dma_init_linklist_xfer(m_drv_id, desc.channel, desc.ll_desc[0].desc);
	endtask
	
	task free_addresses(wb_dma_descriptor desc);
		wb_dma_ll_descriptor ll_desc;
		
		if ($cast(ll_desc, desc)) begin
			// Linked-list descriptor
			for (int i=0; i<ll_desc.ll_desc_sz; i++) begin
				m_mem_mgr.free(ll_desc.ll_desc[i].desc);
				m_mem_mgr.free(ll_desc.ll_desc[i].src_addr);
				m_mem_mgr.free(ll_desc.ll_desc[i].dst_addr);
			end
		end else begin
			// Single descriptor
			m_mem_mgr.free(desc.src_addr);
			m_mem_mgr.free(desc.dst_addr);
		end
	endtask

	task wait_done();
		int unsigned done_mask;
		
		while (m_active_channels != 0) begin
			wb_dma_drv_poll(m_drv_id, done_mask);
			
			$display("POLL: 'h%08h", done_mask);
			
			for (int i=0; i<31; i++) begin
				if (done_mask & (1 << i)) begin
					wb_dma_descriptor desc = m_active_descs[i];
					m_active_descs[i] = null;
					
					if (m_done_ap) begin
						m_done_ap.write(desc);
					end
					
					free_addresses(desc);
						
					m_active_channels[i] = 0;
				end
			end
		
			// TODO: update for interrupt-driven
			if (m_active_channels != 0) begin
				#10us;
			end
		end
	endtask

endclass


