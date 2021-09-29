/****************************************************************************
 * wb_master_api_pkg.sv
 ****************************************************************************/

/**
 * Package: wb_master_api_pkg
 * 
 * TODO: Add package documentation
 */
package wb_master_api_pkg;
	
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	class wb_master_api;
		
		virtual task reset();
			// TODO:
		endtask
		
		virtual task response(bit ERR);
			// TODO:
		endtask
		
	endclass
`endif


endpackage


