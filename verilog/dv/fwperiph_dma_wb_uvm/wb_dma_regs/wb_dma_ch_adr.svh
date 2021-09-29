/****************************************************************************
 * wb_dma_ch_adr.svh
 ****************************************************************************/

/**
 * Class: wb_dma_ch_adr
 * 
 * TODO: Add class documentation
 */
class wb_dma_ch_adr extends uvm_reg;
	`uvm_object_utils(wb_dma_ch_adr)
		
	uvm_reg_field			ADR;
		
	function new(string name="wb_dma_ch_adr");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
		
	virtual function void build();
		ADR = uvm_reg_field::type_id::create("ADR");
		ADR.configure(this, 30, 2, "RW", 1, 0, 1, 0, 0);
	endfunction
		
endclass 
 


