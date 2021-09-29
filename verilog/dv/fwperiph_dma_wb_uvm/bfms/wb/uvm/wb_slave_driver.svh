

class wb_slave_driver `wb_slave_plist extends uvm_driver #(wb_slave_seq_item);
	
	typedef wb_slave_driver `wb_slave_params this_t;
	typedef wb_slave_config `wb_slave_params cfg_t;
	
	`uvm_component_param_utils (this_t);

	const string report_id = "wb_slave_driver";
	
	uvm_analysis_port #(wb_slave_seq_item)		ap;
	
	cfg_t													m_cfg;
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		ap = new("ap", this);
		
		m_cfg = cfg_t::get_config(this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		wb_slave_seq_item		item;
		`wb_slave_vif_t vif = m_cfg.vif;
	
		// Prime the pump
		seq_item_port.get_next_item(item);
		
		forever begin
			
			// Wait for a request
			vif.wb_slave_bfm_wait_req(
					item.addr,
					item.byte_en,
					item.is_write);
			vif.wb_slave_bfm_get_data(0, item.data);
			
			// Send the item to the analysis port
			ap.write(item);
		
			// Notify the caller of the request
			seq_item_port.item_done();
			
			// Wait for a response
			seq_item_port.get_next_item(item);
			
			// Acknowlege the request
			vif.wb_slave_bfm_set_data(0, item.data);
			vif.wb_slave_bfm_ack_req();
		end
	endtask
endclass



