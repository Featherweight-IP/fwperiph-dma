
/****************************************************************************
 * wb_dma_sw_driver_test.svh
 ****************************************************************************/

  
/**
 * Class: wb_dma_sw_driver_test
 * 
 * TODO: Add class documentation
 */
class wb_dma_sw_driver_test extends wb_dma_test_base;
	`uvm_component_utils(wb_dma_sw_driver_test)
	zephyr_cosim_agent			m_cosim_agent;

	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Build 
		m_cosim_agent = zephyr_cosim_agent::type_id::create("m_cosim_agent", this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// Connect the Zephyr agent to the register sequencer
		m_cosim_agent.set_sequencer(
				m_env.m_master_agent.m_seqr,
				m_env.m_reg_adapter);
	endfunction

endclass


