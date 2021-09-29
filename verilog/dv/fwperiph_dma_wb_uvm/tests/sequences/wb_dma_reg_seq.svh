/****************************************************************************
 * wb_dma_reg_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_reg_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_reg_seq extends uvm_sequence;
	`uvm_object_utils(wb_dma_reg_seq)
	
	wb_dma_reg_block			m_regs;
	
	function new(string name="wb_dma_reg_seq");
		super.new(name);
	endfunction


endclass


