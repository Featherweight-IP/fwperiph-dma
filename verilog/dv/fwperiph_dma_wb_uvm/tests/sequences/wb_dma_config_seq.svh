/****************************************************************************
 * wb_dma_config_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_config_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_config_seq extends uvm_sequence;
	`uvm_object_utils(wb_dma_config_seq)
	
	wb_dma_reg_block					m_regs;
	uvm_analysis_port #(wb_dma_config)	m_cfg_ap;
	
	virtual task body();
		// NOP
	endtask


	/**
	 * Task: finish_item
	 *
	 * Override from class 
	 */
	virtual task finish_item(
		input uvm_sequence_item item, 
		input int set_priority=-1);
		wb_dma_config cfg;
		
		if (!$cast(cfg, item)) begin
			`uvm_fatal(get_name(), "item is not an instance of wb_dma_config");
		end
		
		for (int i=0; i<31; i++) begin
			// Configure channel priorities
			m_regs.ch[i].CSR.PRI.set(cfg.channel_pri[i]);
		end
		
		m_regs.int_msk_a.set(cfg.int_msk_a);
		m_regs.int_msk_b.set(cfg.int_msk_b);
		
		if (m_cfg_ap != null) begin
			m_cfg_ap.write(cfg);
		end

	endtask

	/**
	 * Task: start_item
	 *
	 * Override from class 
	 */
	virtual task start_item(
		input uvm_sequence_item item, 
		input int set_priority=-1, 
		input uvm_sequencer_base sequencer=null);
		// NOP
	endtask

	


endclass


