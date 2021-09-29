
typedef class event_agent;
typedef class event_monitor;

`ifdef HAVE_HDL_VIRTUAL_INTERFACE
class event_api_impl `event_plist extends event_api;
	event_monitor `event_params		m_monitor;
	
	virtual task event_update(longint unsigned v);
		m_monitor.event_update(v);
	endtask
endclass
`endif

/**
 * Class: event_agent
 */
class event_agent `event_plist extends uvm_agent;
	
	typedef event_agent  `event_params this_t;
	`uvm_component_param_utils (this_t)


	const string report_id = "event_agent";
	
	typedef event_driver `event_params 	drv_t;
	typedef event_config `event_params 	cfg_t;
	typedef event_monitor `event_params	mon_t;

	drv_t													m_driver;
	uvm_sequencer #(event_seq_item)			m_seqr;
	mon_t													m_monitor;
	
	uvm_analysis_port #(event_seq_item)		m_mon_out_ap;
	uvm_analysis_port #(event_seq_item)		m_drv_out_ap;
	
	cfg_t													m_cfg;

`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	event_api_impl `event_params							m_api;
`endif
	
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
		
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
		m_api = new();
		m_api.m_monitor = m_monitor;
		
		m_cfg.vif.m_api = m_api;
`endif
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



