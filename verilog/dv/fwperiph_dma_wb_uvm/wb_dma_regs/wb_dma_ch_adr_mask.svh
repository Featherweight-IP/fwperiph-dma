/****************************************************************************
 * wb_dma_ch_adr_mask.svh
 ****************************************************************************/

/**
 * Class: wb_dma_ch_adr_mask
 * 
 * TODO: Add class documentation
 */
class wb_dma_ch_adr_mask extends uvm_reg;
	`uvm_object_utils(wb_dma_ch_adr_mask)
		
	uvm_reg_field			MASK;

	function new(string name="wb_dma_ch_adr_mask");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
		
	virtual function void build();
		MASK = uvm_reg_field::type_id::create("MASK");
		MASK.configure(this, 28, 4, "RW", 0, 0, 1, 0, 0);
	endfunction
		
endclass 
 


