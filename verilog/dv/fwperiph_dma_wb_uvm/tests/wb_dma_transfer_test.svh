
class wb_dma_transfer_test extends wb_dma_test_base;
	
	`uvm_component_utils(wb_dma_transfer_test)
	
	/****************************************************************
	 * Data Fields
	 ****************************************************************/
	wb_dma_single_transfer_descriptor_cov			m_single_transfer_descriptor_cov;
	
	/****************************************************************
	 * new()
	 ****************************************************************/
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction

	/****************************************************************
	 * build_phase()
	 ****************************************************************/
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		m_single_transfer_descriptor_cov = wb_dma_single_transfer_descriptor_cov::type_id::create(
				"m_single_transfer_descriptor_cov", this);
	endfunction

	/****************************************************************
	 * connect_phase()
	 ****************************************************************/
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		m_env.m_done_ap.connect(m_single_transfer_descriptor_cov.analysis_export);
	endfunction

	/****************************************************************
	 * run_phase()
	 ****************************************************************/
	task run_phase(uvm_phase phase);
		wb_dma_reg_reset_seq rst_seq = wb_dma_reg_reset_seq::type_id::create("rst_seq");
		wb_dma_transfer_seq transfer_seq;
		wb_slave_mem_seq #(32, 32) s0_seq, s1_seq;
		wb_dma_config_seq cfg_seq;
	
		phase.raise_objection(this, "Main");
		// First reset registers
		rst_seq.m_regs = m_env.m_dma_regs;
		rst_seq.start(null);
		
		// Now, start slave sequences
		s0_seq = wb_slave_mem_seq #(32,32)::type_id::create("s0_seq");
		s0_seq.m_mem_mgr = m_env.m_mem_mgr;
		s1_seq = wb_slave_mem_seq #(32,32)::type_id::create("s1_seq");
		s1_seq.m_mem_mgr = m_env.m_mem_mgr;
		fork
			s0_seq.start(m_env.m_s0_agent.m_seqr);
			s1_seq.start(m_env.m_s1_agent.m_seqr);
		join_none
		
		// Run config sequence
		cfg_seq = wb_dma_config_seq::type_id::create("cfg_seq");
		cfg_seq.m_regs = m_env.m_dma_regs;
		cfg_seq.m_cfg_ap = m_env.m_cfg_ap;
		cfg_seq.start(null);
		
		
		// Now, create and run a transfer sequence
		transfer_seq = wb_dma_transfer_seq::type_id::create("transfer_seq");
		transfer_seq.m_regs = m_env.m_dma_regs;
		transfer_seq.m_start_ap = m_env.m_start_ap;
		transfer_seq.m_done_ap = m_env.m_done_ap;
		transfer_seq.m_mem_mgr = m_env.m_mem_mgr;
		transfer_seq.start(null);
		
			
		phase.drop_objection(this, "Main");
	endtask
	
endclass



