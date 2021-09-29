/****************************************************************************
 * wb_dma_multixfer_vseq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_multixfer_vseq
 * 
 * TODO: Add class documentation
 */
class wb_dma_multixfer_vseq extends wb_dma_transfer_seq;
	`uvm_object_utils(wb_dma_multixfer_vseq)
	
	// Have registers pre-set

	// Method to track available channels
	wb_dma_directed_transfer_seq	m_active_seqs[$];
	semaphore						m_done_sem = new(0);
	
	function new(string name="wb_dma_multixfer_vseq");
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
		wb_dma_descriptor desc;
		wb_dma_directed_transfer_seq seq = wb_dma_directed_transfer_seq::type_id::create("seq");

		if (!$cast(desc, item)) begin
			`uvm_fatal(get_name(), "Failed to cast item to wb_dma_descriptor");
		end
		
		seq.desc = desc;
		seq.m_mem_mgr = m_mem_mgr;
		seq.m_regs = m_regs;
		seq.m_done_ap = m_done_ap;
		m_active_seqs.push_back(seq);
	
		fork
			begin
				$display("--> START %0d", seq.desc.channel);
				seq.start(null);
				$display("<-- FINISH %0d", seq.desc.channel);
				for (int i=0; i<m_active_seqs.size(); i++) begin
					if (m_active_seqs[i] == seq) begin
						m_active_seqs.delete(i);
						break;
					end
				end
				m_done_sem.put(1);
			end
		join_none
	endtask

	task wait_done();
		while (m_active_seqs.size() > 0) begin
			// First, clear the semaphore
			while (m_done_sem.try_get()) begin
				m_done_sem.get();
			end
			
			// Now, wait for the next descriptor to complete
			m_done_sem.get();
		end
	endtask

endclass


