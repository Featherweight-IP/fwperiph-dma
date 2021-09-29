
`include "uvm_macros.svh"

package wb_dma_env_pkg;
	import uvm_pkg::*;
	import wb_dma_regs_pkg::*;
	import wb_master_agent_pkg::*;
	import wb_slave_agent_pkg::*;
	import event_agent_pkg::*;
	import mem_mgr_pkg::*;

	`include "wb_dma_reg_adapter.svh"
	`include "wb_slave_mem_seq.svh"
	`include "wb_dma_descriptor.svh"
	`include "wb_dma_ll_descriptor.svh"
	`include "wb_dma_scoreboard.svh"
	`include "wb_dma_config.svh"
	`include "wb_dma_env.svh"
	
endpackage
