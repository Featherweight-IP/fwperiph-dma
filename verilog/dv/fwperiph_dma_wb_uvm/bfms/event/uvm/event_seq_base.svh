

class event_seq_base `event_plist extends uvm_sequence #(event_seq_item);
	typedef event_seq_base `event_params this_t;
	`uvm_object_param_utils(this_t)
	
	static const string report_id = "event_seq_base";
	
	function new(string name="event_seq_base");
		super.new(name);
	endfunction
	
	task body();
		`uvm_error(report_id, "base-class body task not overridden");
	endtask
	
endclass



