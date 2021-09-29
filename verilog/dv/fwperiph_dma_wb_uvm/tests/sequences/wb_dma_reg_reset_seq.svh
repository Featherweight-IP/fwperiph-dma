/****************************************************************************
 * wb_dma_reg_reset_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_reg_reset_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_reg_reset_seq extends wb_dma_reg_seq;
	`uvm_object_utils(wb_dma_reg_reset_seq)

	/**
	 * Task: body
	 *
	 * Override from class 
	 */
	virtual task body();
		uvm_status_e	status;
		uvm_reg_data_t	data = 0;
		
		for (int i=0; i<31; i++) begin
			m_regs.ch[i].CSR.write(status, data);
			m_regs.ch[i].A0.write(status, data);
			m_regs.ch[i].A1.write(status, data);
			m_regs.ch[i].AM0.write(status, data);
			m_regs.ch[i].AM1.write(status, data);
			m_regs.ch[i].DESC.write(status, data);
		end

	endtask

	

endclass


