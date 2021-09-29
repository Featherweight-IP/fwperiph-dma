/****************************************************************************
 * wb_dma_csr.svh
 ****************************************************************************/

/**
 * Class: wb_dma_csr
 * 
 * TODO: Add class documentation
 */
class wb_dma_csr extends uvm_reg;
	`uvm_object_utils(wb_dma_csr)
		
	// Fields
	rand uvm_reg_field		PAUSE;
		
	function new(string name="wb_dma_csr");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
		PAUSE = uvm_reg_field::type_id::create("PAUSE");
		PAUSE.configure(this, 1, 0, "RW", 1, 0, 1, 0, 0);
	endfunction
		
endclass 
 


