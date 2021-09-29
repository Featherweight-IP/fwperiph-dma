/****************************************************************************
 * wb_dma_int_msk.svh
 ****************************************************************************/

/**
 * Class: wb_dma_int_msk
 * 
 * TODO: Add class documentation
 */
class wb_dma_int_msk extends uvm_reg;
	`uvm_object_utils(wb_dma_int_msk)
		
	rand uvm_reg_field		MASK;
		
	function new(string name="wb_dma_int_msk");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
		
	virtual function void build();
		MASK = uvm_reg_field::type_id::create("MASK");
		MASK.configure(this, 31, 0, "RW", 0, 0, 1, 0, 0);
	endfunction
		
endclass 
 


