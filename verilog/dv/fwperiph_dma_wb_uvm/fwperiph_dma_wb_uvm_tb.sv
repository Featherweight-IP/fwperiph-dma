/****************************************************************************
 * fwperiph_dma_wb_uvm_tb.sv
 ****************************************************************************/
`include "uvm_macros.svh"
`include "wishbone_macros.svh"
  
/**
 * Module: fwperiph_dma_wb_uvm_tb
 * 
 * TODO: Add module documentation
 */
module fwperiph_dma_wb_uvm_tb(input clock);
	import uvm_pkg::*;
	import wb_dma_tests_pkg::*;
	
	import wb_master_agent_pkg::*;
	import wb_slave_agent_pkg::*;
	import event_agent_pkg::*;
	
	parameter int WB_ADDR_WIDTH=32;
	parameter int WB_DATA_WIDTH=32;

`ifdef HAVE_HDL_CLOCKGEN
    reg clock_r = 0;
    initial begin
        forever begin
            #10ns;
	    clock_r <= ~clock_r;
	end
    end
    assign clock = clock_r;
`endif
	
	reg reset /* verilator public */ = 0;
	reg[7:0]		rst_cnt = 0;
	
	always @(posedge clock) begin
		if (rst_cnt == 20) begin
			reset <= 0;
		end else begin
			if (rst_cnt == 2) begin
				reset <= 1;
			end
			rst_cnt <= rst_cnt + 1;
		end
	end	
	
	`WB_WIRES(bfm2reg_, 32, 32);
	`WB_WIRES(duti0_, 32, 32);
	`WB_WIRES(duti1_, 32, 32);
	
	wire[3:0]				dma_req_i = 0;
	wire[3:0]				dma_ack_o;
	wire[3:0]				dma_nd_i = 0;
	wire[3:0]				dma_rest_i = 0;
	
	wire					inta_o, intb_o;	
	
	wb_if #( 
			.WB_ADDR_WIDTH(WB_ADDR_WIDTH),
			.WB_DATA_WIDTH(WB_DATA_WIDTH)
		) bfm2s0 ();
	
	wb_if #( 
			.WB_ADDR_WIDTH(WB_ADDR_WIDTH),
			.WB_DATA_WIDTH(WB_DATA_WIDTH)
		) bfm2s0_1 ();
	
	wb_if #( 
			.WB_ADDR_WIDTH(WB_ADDR_WIDTH),
			.WB_DATA_WIDTH(WB_DATA_WIDTH)
		) stub2s1 ();
	
	wb_if #( 
			.WB_ADDR_WIDTH(WB_ADDR_WIDTH),
			.WB_DATA_WIDTH(WB_DATA_WIDTH)
		) m02bfm ();
	wb_if #( 
			.WB_ADDR_WIDTH(WB_ADDR_WIDTH),
			.WB_DATA_WIDTH(WB_DATA_WIDTH)
		) m12bfm ();	
	
	wb_master_bfm #(
			.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
			.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_master_bfm (
			.clk            (clock         ), 
			.rstn           (~reset        ), 
			.master         (bfm2s0.master ));
	
	wb_slave_bfm #(
			.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
			.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_s0_bfm (
			.clk            (clock           ), 
			.rstn           (~reset        ), 
			.slave          (m02bfm.slave  ));
	
	wb_slave_bfm #(
			.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
			.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_s1_bfm (
			.clk            (clock           ), 
			.rstn           (~reset        ), 
			.slave          (m12bfm.slave  ));	
	
	fwperiph_dma_wb #(
			// chXX_conf = { CBUF, ED, ARS, EN }
			.ch_count(4),
			.ch0_conf('hF),
			.ch1_conf('hF),
			.ch2_conf('hF),
			.ch3_conf('hF)
		) u_dut (
			.clock(					clock), 
			.reset(					reset),

			.rt_adr(bfm2s0.ADR),
			.rt_dat_w(bfm2s0.DAT_W),
			.rt_dat_r(bfm2s0.DAT_R),
			.rt_cyc(bfm2s0.CYC),
			.rt_err(bfm2s0.ERR),
			.rt_sel(bfm2s0.SEL),
			.rt_stb(bfm2s0.STB),
			.rt_ack(bfm2s0.ACK),
			.rt_we(bfm2s0.WE),
			
			.i0_adr(m02bfm.ADR),
			.i0_dat_w(m02bfm.DAT_W),
			.i0_dat_r(m02bfm.DAT_R),
			.i0_cyc(m02bfm.CYC),
			.i0_err(m02bfm.ERR),
			.i0_sel(m02bfm.SEL),
			.i0_stb(m02bfm.STB),
			.i0_ack(m02bfm.ACK),
			.i0_we(m02bfm.WE),
			
			.i1_adr(m12bfm.ADR),
			.i1_dat_w(m12bfm.DAT_W),
			.i1_dat_r(m12bfm.DAT_R),
			.i1_cyc(m12bfm.CYC),
			.i1_err(m12bfm.ERR),
			.i1_sel(m12bfm.SEL),
			.i1_stb(m12bfm.STB),
			.i1_ack(m12bfm.ACK),
			.i1_we(m12bfm.WE),			

			.dma_req_i(				dma_req_i), 
			.dma_ack_o(				dma_ack_o), 
			.dma_nd_i(				dma_nd_i), 
			.dma_rest_i(			dma_rest_i),

			.inta_o(				inta_o), 
			.intb_o( 				intb_o)
		);	
	
	event_bfm #(1) u_irq(
			.clk(clock),
			.rst(reset),
			.ev(inta_o)
		);	

	typedef wb_master_config #(WB_ADDR_WIDTH, WB_DATA_WIDTH) cfg_m_t;
	typedef wb_slave_config #(WB_ADDR_WIDTH, WB_DATA_WIDTH) cfg_s_t;
	
	initial begin
		automatic cfg_m_t cfg_m = cfg_m_t::type_id::create("cfg_m");
		automatic cfg_s_t cfg_s0 = cfg_s_t::type_id::create("cfg_s0");
		automatic cfg_s_t cfg_s1 = cfg_s_t::type_id::create("cfg_s1");
		automatic event_config cfg_e = event_config::type_id::create("cfg_e");
		
		cfg_m.vif = u_master_bfm.u_core;
		uvm_config_db #(cfg_m_t)::set(uvm_top, "*m_master_agent*",
				cfg_m_t::report_id, cfg_m);
		
		cfg_s0.vif = u_s0_bfm.u_core;
		uvm_config_db #(cfg_s_t)::set(uvm_top, "*m_s0_agent*",
				cfg_s_t::report_id, cfg_s0);
		cfg_s1.vif = u_s1_bfm.u_core;
		uvm_config_db #(cfg_s_t)::set(uvm_top, "*m_s1_agent*",
				cfg_s_t::report_id, cfg_s1);
		
		cfg_e.vif = u_irq.u_core;
		uvm_config_db #(event_config)::set(uvm_top, "*m_irq_agent*",
				event_config::report_id, cfg_e);
		
		run_test();
	end


endmodule


