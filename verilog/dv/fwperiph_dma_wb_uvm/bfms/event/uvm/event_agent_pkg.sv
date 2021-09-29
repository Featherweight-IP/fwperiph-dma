
`include "uvm_macros.svh"

`define event_plist
`define event_params
`define event_vif_t virtual event_bfm_core 

package event_agent_pkg;
	import uvm_pkg::*;
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	import event_api_pkg::*;
`endif

	`include "event_config.svh"
	`include "event_seq_item.svh"
	`include "event_driver.svh"
	`include "event_monitor.svh"
	`include "event_seq_base.svh"
	`include "event_agent.svh"
endpackage



