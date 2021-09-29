/****************************************************************************
 * wb_dma_ch_sz.svh
 ****************************************************************************/

/**
 * Class: wb_dma_ch_sz
 * 
 * TODO: Add class documentation
 */
class wb_dma_ch_sz extends uvm_reg;
	`uvm_object_utils(wb_dma_ch_sz)
		
	uvm_reg_field			CHK_SZ;
	uvm_reg_field			TOT_SZ;
		
	function new(string name="wb_dma_ch_csr");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
		
	virtual function void build();
		CHK_SZ = uvm_reg_field::type_id::create("CHK_SZ");
		CHK_SZ.configure(this, 9, 16, "RW", 0, 0, 1, 0, 0);
		TOT_SZ = uvm_reg_field::type_id::create("TOT_SZ");
		TOT_SZ.configure(this, 12, 0, "RW", 0, 0, 1, 0, 0);
	endfunction
		
endclass 
 


