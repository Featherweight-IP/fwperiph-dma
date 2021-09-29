
`include "uvm_macros.svh"

`define wb_master_plist  #(parameter int ADDRESS_WIDTH=32, parameter int DATA_WIDTH=32)
`define wb_master_params #(ADDRESS_WIDTH, DATA_WIDTH)
`define wb_master_vif_t virtual wb_master_bfm_core `wb_master_params

package wb_master_agent_pkg;
	import uvm_pkg::*;
	import sv_bfms_api_pkg::*;
	import wb_master_api_pkg::*;

	`include "wb_master_rw_api.svh"
	`include "wb_master_config.svh"
	`include "wb_master_seq_item.svh"
	`include "wb_master_driver.svh"
	`include "wb_master_monitor.svh"
	`include "wb_master_seq_base.svh"
	`include "wb_master_reg_adapter.svh"
	`include "wb_master_agent.svh"
endpackage



