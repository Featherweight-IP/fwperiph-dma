

/**
 * Class: wb_slave_agent
 */
class wb_slave_agent `wb_slave_plist extends uvm_agent;
	
	typedef wb_slave_agent  `wb_slave_params this_t;
	`uvm_component_param_utils (this_t)


	const string report_id = "wb_slave_agent";
	
	typedef wb_slave_driver `wb_slave_params 	drv_t;
	typedef wb_slave_config `wb_slave_params 	cfg_t;
	typedef wb_slave_monitor `wb_slave_params	mon_t;

	drv_t													m_driver;
	uvm_sequencer #(wb_slave_seq_item)			m_seqr;
	mon_t													m_monitor;
	
	uvm_analysis_port #(wb_slave_seq_item)		m_mon_out_ap;
	uvm_analysis_port #(wb_slave_seq_item)		m_drv_out_ap;
	
	cfg_t													m_cfg;
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		// Obtain the config object for this agent
		m_cfg = cfg_t::get_config(this);
		
		if (m_cfg.has_driver) begin
			m_driver = drv_t::type_id::create("m_driver", this);
			
			// Create driver analysis port
			m_drv_out_ap = new("m_drv_out_ap", this);
		end
		
		if (m_cfg.has_sequencer) begin
			m_seqr = new("m_seqr", this);
		end
	
		if (m_cfg.has_monitor) begin
			m_monitor = mon_t::type_id::create("m_monitor", this);
			
			// Create the monitor analysis port
			m_mon_out_ap = new("m_mon_out_ap", this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// Connect the driver and sequencer
		if (m_cfg.has_driver && m_cfg.has_sequencer) begin
			m_driver.seq_item_port.connect(m_seqr.seq_item_export);
		end
		
		if (m_cfg.has_monitor) begin
			// Connect the monitor to the monitor AP
			m_monitor.ap.connect(m_mon_out_ap);
		end
		
		if (m_cfg.has_driver) begin
			// Connect the driver to the driver AP
			m_driver.ap.connect(m_drv_out_ap);
		end
		
	endfunction
	

endclass



