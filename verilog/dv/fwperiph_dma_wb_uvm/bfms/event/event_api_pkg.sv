/****************************************************************************
 * event_api_pkg.sv
 ****************************************************************************/

/**
 * Package: event_api_pkg
 * 
 * TODO: Add package documentation
 */
package event_api_pkg;
	
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	class event_api;
		
		virtual task event_update(longint unsigned v);
		endtask
		
	endclass
`endif


endpackage


