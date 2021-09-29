
class wb_dma_test_base extends uvm_test;
	
	`uvm_component_utils(wb_dma_test_base)
	
	wb_dma_env				m_env;
	
	function new(string name, uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		m_env = wb_dma_env::type_id::create("m_env", this);
	endfunction
	


	/**
	 * Function: report_phase
	 *
	 * Override from class 
	 */
	virtual function void report_phase(input uvm_phase phase);
		uvm_report_server svr = get_report_server();
		int err = svr.get_severity_count(UVM_ERROR);
		int fatal = svr.get_severity_count(UVM_FATAL);
		string testname;
		
		void'($value$plusargs("TESTNAME=%s", testname));
		
		if (err > 0 || fatal > 0) begin
			`uvm_info(get_name(), $psprintf("FAIL: %0s", testname), UVM_LOW);
		end else begin
			`uvm_info(get_name(), $psprintf("PASS: %0s", testname), UVM_LOW);
		end
	endfunction

	
	
endclass

