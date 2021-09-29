/****************************************************************************
 * wb_slave_mem_seq.svh
 ****************************************************************************/

/**
 * Class: wb_slave_mem_seq
 * 
 * TODO: Add class documentation
 */
class wb_slave_mem_seq #(parameter int ADDRESS_WIDTH=32, parameter int DATA_WIDTH=32) extends wb_slave_seq_base;
	typedef wb_slave_mem_seq #(ADDRESS_WIDTH,DATA_WIDTH) this_t;
	`uvm_object_param_utils (this_t)
	
	mem_mgr						m_mem_mgr;


	/**
	 * Task: body
	 *
	 * Override from class 
	 */
	virtual task body();
		wb_slave_seq_item #(ADDRESS_WIDTH, DATA_WIDTH) item = 
			wb_slave_seq_item #(ADDRESS_WIDTH,DATA_WIDTH)::type_id::create("item");
			
		start_item(item);
		
		forever begin
			finish_item(item); // finish first item, returning request
			
			if (item.is_write) begin
				m_mem_mgr.write32(item.addr, item.data);
			end else begin
				m_mem_mgr.read32(item.addr, item.data);
			end
		
//			$display("%0t %0s: 'h%08h 'h%08h",
//					$time,
//					(item.is_write)?"WRITE":"READ",
//					item.addr, item.data);
			
			start_item(item); // start next item
		end

	endtask

	

	

endclass


