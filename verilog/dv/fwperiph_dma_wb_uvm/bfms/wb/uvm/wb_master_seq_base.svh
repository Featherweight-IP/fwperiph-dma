

class wb_master_seq_base `wb_master_plist extends uvm_sequence #(wb_master_seq_item);
	typedef wb_master_seq_base `wb_master_params this_t;
	`uvm_object_param_utils(this_t)
	
	static const string report_id = "wb_master_seq_base";
	
	function new(string name="wb_master_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



