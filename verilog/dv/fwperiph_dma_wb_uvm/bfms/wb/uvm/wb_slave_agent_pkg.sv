
`include "uvm_macros.svh"

`define wb_slave_plist  #(parameter int ADDRESS_WIDTH=32, parameter int DATA_WIDTH=32)
`define wb_slave_params #(ADDRESS_WIDTH,DATA_WIDTH)
`define wb_slave_vif_t virtual wb_slave_bfm_core `wb_slave_params

package wb_slave_agent_pkg;
	import uvm_pkg::*;

	`include "wb_slave_config.svh"
	`include "wb_slave_seq_item.svh"
	`include "wb_slave_driver.svh"
	`include "wb_slave_monitor.svh"
	`include "wb_slave_seq_base.svh"
	`include "wb_slave_agent.svh"
endpackage



