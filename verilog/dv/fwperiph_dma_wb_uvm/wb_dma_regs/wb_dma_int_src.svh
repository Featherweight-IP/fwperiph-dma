/****************************************************************************
 * wb_dma_int_src.svh
 ****************************************************************************/

/**
 * Class: wb_dma_int_src
 * 
 * TODO: Add class documentation
 */
class wb_dma_int_src extends uvm_reg;
	`uvm_object_utils(wb_dma_int_src)
		
	rand uvm_reg_field		SRC;
		
	function new(string name="wb_dma_int_src");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
		
	virtual function void build();
		SRC = uvm_reg_field::type_id::create("SRC");
		SRC.configure(this, 31, 0, "RW", 0, 0, 1, 0, 0);
	endfunction
		
endclass 
 


