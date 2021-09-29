/****************************************************************************
 * wb_master_rw_api.svh
 ****************************************************************************/

/**
 * Class: wb_master_rw_api
 * 
 * TODO: Add class documentation
 */
typedef class wb_master_agent;
class wb_master_rw_api `wb_master_plist extends sv_bfms_rw_api_if;
	typedef wb_master_agent `wb_master_params agent_t;

	agent_t							m_agent;

	function new(agent_t agent);
		m_agent = agent;
	endfunction


	/**
	 * Task: read32
	 *
	 * Override from class 
	 */
	virtual task read32(input bit[31:0] addr, output bit[31:0] data);
		m_agent.m_driver.read32(addr, data);
	endtask

	/**
	 * Task: read8
	 *
	 * Override from class 
	 */
	virtual task read8(input bit[31:0] addr, output bit[7:0] data);
		m_agent.m_driver.read8(addr, data);
	endtask

	/**
	 * Task: read16
	 *
	 * Override from class 
	 */
	virtual task read16(input bit[31:0] addr, output bit[15:0] data);
		m_agent.m_driver.read16(addr, data);
	endtask
	
	/**
	 * Task: write32
	 *
	 * Override from class 
	 */
	virtual task write32(input bit[31:0] addr, input bit[31:0] data);
		m_agent.m_driver.write32(addr, data);
	endtask

	/**
	 * Task: write8
	 *
	 * Override from class 
	 */
	virtual task write8(input bit[31:0] addr, input bit[7:0] data);
		m_agent.m_driver.write8(addr, data);
	endtask

	/**
	 * Task: write16
	 *
	 * Override from class 
	 */
	virtual task write16(input bit[31:0] addr, input bit[15:0] data);
		m_agent.m_driver.write16(addr, data);
	endtask	

endclass


