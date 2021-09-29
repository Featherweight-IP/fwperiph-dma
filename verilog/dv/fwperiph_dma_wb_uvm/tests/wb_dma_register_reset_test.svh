
class wb_dma_register_reset_test extends wb_dma_test_base;
	
	`uvm_component_utils(wb_dma_register_reset_test)
	
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
		uvm_reg_data_t		value;
		int					errors=0;
//		sv_bfms_rw_api_if rw_api;
//		
//		rw_api = m_env.m_master_agent.get_api();
//		
//		phase.raise_objection(this, "Main");
//	
//		repeat (16) begin
//			$display("--> write32 %0t", $time);
//			m_env.m_dma_regs.csr.read(status, value);
//			if (m_env.m_dma_regs.csr.get_reset() != value) begin
//				`uvm_error (get_name(), $psprintf("Incorrect reset value for CSR: Expect='h%08h Receive='h%08h",
//							value, m_env.m_dma_regs.csr.get_reset()));
//			end
//			$display("<-- write32 %0t", $time);
//		end
//
//		phase.drop_objection(this, "Main");
	endtask
	
endclass



