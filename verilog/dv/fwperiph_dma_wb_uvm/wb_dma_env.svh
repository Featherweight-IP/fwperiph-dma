
class wb_dma_env extends uvm_env;
	`uvm_component_utils(wb_dma_env)
	
	parameter WB_ADDR_WIDTH=32;
	parameter WB_DATA_WIDTH=32;
	
	typedef wb_master_agent #(WB_ADDR_WIDTH, WB_DATA_WIDTH) wb_master_agent_t;
	typedef wb_slave_agent #(WB_ADDR_WIDTH, WB_DATA_WIDTH) wb_slave_agent_t;
	typedef wb_dma_reg_adapter #(WB_ADDR_WIDTH,WB_DATA_WIDTH) wb_reg_adapter_t;
	
	wb_dma_reg_block							m_dma_regs;
	wb_master_agent_t							m_master_agent;
	wb_slave_agent_t							m_s0_agent;
	wb_slave_agent_t							m_s1_agent;
	event_agent									m_irq_agent;
	wb_reg_adapter_t							m_reg_adapter;
	mem_mgr										m_mem_mgr;
	
	wb_dma_scoreboard							m_scoreboard;
	
	uvm_analysis_port #(wb_dma_descriptor)		m_start_ap;
	uvm_analysis_port #(wb_dma_descriptor)		m_done_ap;
	
	uvm_analysis_port #(wb_dma_config)			m_cfg_ap;

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	/**
	 * Function: build_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void build_phase(input uvm_phase phase);
		super.build_phase(phase);
		
		m_start_ap = new("m_start_ap", this);
		m_done_ap = new("m_done_ap", this);
		m_cfg_ap = new("m_cfg_ap", this);
		
		m_dma_regs = wb_dma_reg_block::type_id::create("m_dma_regs");
		m_dma_regs.build();
		
		m_master_agent = wb_master_agent_t::type_id::create("m_master_agent", this);
		m_s0_agent = wb_slave_agent_t::type_id::create("m_s0_agent", this);
		m_s1_agent = wb_slave_agent_t::type_id::create("m_s1_agent", this);
		
		m_irq_agent = event_agent::type_id::create("m_irq_agent", this);
		
		m_reg_adapter = wb_reg_adapter_t::type_id::create("m_reg_adapter");
		
		m_mem_mgr = mem_mgr::type_id::create("m_mem_mgr", this);
		
		m_scoreboard = wb_dma_scoreboard::type_id::create("m_scoreboard", this);
	endfunction

	/**
	 * Function: connect_phase
	 *
	 * Override from class uvm_component
	 */
	virtual function void connect_phase(input uvm_phase phase);
		super.connect_phase(phase);
		
		m_dma_regs.default_map.set_sequencer(m_master_agent.m_seqr, m_reg_adapter);
		m_dma_regs.default_map.set_auto_predict(1);
		
		m_done_ap.connect(m_scoreboard.done_ap);
		
		m_scoreboard.m_mem_mgr = m_mem_mgr;
	endfunction
	
endclass
