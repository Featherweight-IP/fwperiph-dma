
class wb_dma_register_rw_test extends wb_dma_test_base;
	
	`uvm_component_utils(wb_dma_register_rw_test)
	
	/****************************************************************
	 * Data Fields
	 ****************************************************************/
	
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
	endfunction

	/****************************************************************
	 * connect_phase()
	 ****************************************************************/
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	/****************************************************************
	 * run_phase()
	 ****************************************************************/
	task run_phase(uvm_phase phase);
		uvm_status_e		status;
		uvm_reg_data_t		value, wr_value;
		int					errors=0;
//		sv_bfms_rw_api_if rw_api;
//		
//		rw_api = m_env.m_master_agent.get_api();
//		
//		phase.raise_objection(this, "Main");
//
//		for (int i=0; i<31; i++) begin
//			wr_value = ((i+1) << 2);
//			$display("--> WRITE: (%0d) 'h%08h", i, wr_value);
//			m_env.m_dma_regs.ch[i].A0.write(status, wr_value);
//			$display("<-- WRITE: (%0d) 'h%08h", i, wr_value);
//			m_env.m_dma_regs.ch[i].A0.read(status, value);
//			
//			if (value != wr_value) begin
//				`uvm_error (get_name(), $psprintf("Incorrect read-back from CH=%0d: Expect='h%08h Receive='h%08h",
//							i, wr_value, value));
//			end
//		end
//
//		phase.drop_objection(this, "Main");
	endtask
	
endclass



