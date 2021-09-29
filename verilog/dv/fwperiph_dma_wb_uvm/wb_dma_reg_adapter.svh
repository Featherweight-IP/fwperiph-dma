/****************************************************************************
 * wb_dma_reg_adapter.svh
 ****************************************************************************/

/**
 * Class: wb_dma_reg_adapter
 * 
 * TODO: Add class documentation
 */
class wb_dma_reg_adapter #(ADDRESS_WIDTH=32, DATA_WIDTH=32) extends uvm_reg_adapter;
	typedef wb_dma_reg_adapter #(ADDRESS_WIDTH, DATA_WIDTH) this_t;
	
	`uvm_object_param_utils (this_t)

	function new(string name="wb_dma_reg_adapter");
		super.new(name);
		supports_byte_enable = 1;
	endfunction

	/**
	 * bus2reg()
	 *
	 * Override from class uvm_reg_adapter
	 */
	virtual function void bus2reg(input uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		wb_master_seq_item #(ADDRESS_WIDTH, DATA_WIDTH) bus;
		
		if (!$cast(bus,bus_item)) begin
			`uvm_fatal("NOT_REG_TYPE", "Provided bus_item is not of the correct type");
			return;
		end

		rw.kind			= (bus.is_write)?UVM_WRITE:UVM_READ;
		rw.addr			= bus.addr;
		rw.data			= bus.data;
		rw.byte_en		= bus.byte_en;
		rw.status		= UVM_IS_OK;
	endfunction

	/**
	 * reg2bus()
	 *
	 * Override from class uvm_reg_adapter
	 */
	virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		wb_master_seq_item #(ADDRESS_WIDTH, DATA_WIDTH) bus;

		bus = wb_master_seq_item #(ADDRESS_WIDTH,DATA_WIDTH)::type_id::create("rw");
		
		bus.is_write 	= (rw.kind == UVM_WRITE);
		bus.addr		= rw.addr;
		bus.data		= rw.data;
		bus.byte_en		= rw.byte_en;
		bus.size		= 4;
		
		return bus;
	endfunction
		
endclass


