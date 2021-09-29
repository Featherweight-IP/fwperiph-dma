

class event_monitor `event_plist extends uvm_monitor;

	uvm_analysis_port #(event_seq_item)			ap;

	typedef event_monitor `event_params this_t;
	typedef event_config `event_params  cfg_t;
	typedef event_seq_item `event_params item_t;
	
	cfg_t									m_cfg;
	
	const string report_id = "event_monitor";
	
	`uvm_component_param_utils(this_t)
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		// Obtain the config object
		m_cfg = cfg_t::get_config(this);
	
		// Create the analysis port
		ap = new("ap", this);

	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	virtual task event_update(longint unsigned v);
		item_t item = item_t::type_id::create();
		item.m_value = v;
		
		ap.write(item);
	endtask
	
	task run_phase(uvm_phase phase);
		// TODO: implement event_monitor run_phase
	endtask
	
	
endclass


