
/****************************************************************************
 * fwperiph_dma_wb_4_full_chan_tb.sv
 ****************************************************************************/
`ifdef NEED_TIMESCALE
`timescale 1ns/1ns
`endif

`include "wishbone_macros.svh"
`include "fwperiph_dma_dbg_binds.vh"
  
/**
 * Module: fwperiph_dma_wb_4_full_chan_tb
 * 
 * TODO: Add module documentation
 */
module fwperiph_dma_wb_4_full_chan_tb(input clock);
	
`ifdef HAVE_HDL_CLOCKGEN
	reg clock_r = 0;
	initial begin
		forever begin
`ifdef NEED_TIMESCALE
			#10;
`else
			#10ns;
`endif
			clock_r <= ~clock_r;
		end
	end
	assign clock = clock_r;
`endif
	
`ifdef IVERILOG
	`include "iverilog_control.svh"
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
	
	wb_initiator_bfm #(
			.ADDR_WIDTH(32),
			.DATA_WIDTH(32)
			) u_reg_bfm (
			.clock(							clock),
			.reset(							reset),
			`WB_CONNECT(, bfm2reg_)
			);

	event_bfm #(
			.WIDTH(1)
		) u_irq (
			.clock(clock),
			.reset(reset),
			.data(inta_o)
		);
	
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
	
			`WB_CONNECT(rt_, bfm2reg_),
			`WB_CONNECT(i0_, duti0_),
			`WB_CONNECT(i1_, duti1_),

			.dma_req_i(				dma_req_i), 
			.dma_ack_o(				dma_ack_o), 
			.dma_nd_i(				dma_nd_i), 
			.dma_rest_i(			dma_rest_i),

			.inta_o(				inta_o), 
			.intb_o( 				intb_o)
			);
//`ifdef HAVE_BIND
//`else
//		`BINDINST_FWPERIPH_DMA_DBG(dut_dbg, 4, u_dut);
//`endif

	reg i0_state = 0;
	reg i0_ack = 0;
	assign duti0_ack = i0_ack;
	assign duti0_dat_r = {32{1'b0}};
	always @(posedge clock) begin
		if (reset) begin
			i0_state <= 0;
			i0_ack <= 0;
		end else begin
			case (i0_state)
				0: begin
					if (duti0_cyc && duti0_stb) begin
						i0_state <= 1;
						i0_ack <= 1;
					end
				end
				1: begin
					i0_ack <= 0;
					i0_state <= 0;
				end
			endcase
		end
	end
	
	reg i1_state = 0;
	reg i1_ack = 0;
	assign duti1_ack = i1_ack;
	assign duti1_dat_r = {32{1'b0}};
	always @(posedge clock) begin
		if (reset) begin
			i1_state <= 0;
			i1_ack <= 0;
		end else begin
			case (i1_state)
				0: begin
					if (duti1_cyc && duti1_stb) begin
						i1_state <= 1;
						i1_ack <= 1;
					end
				end
				1: begin
					i1_ack <= 0;
					i1_state <= 0;
				end
			endcase
		end
	end
	
//	wb_target_bfm #(
//			.ADDR_WIDTH(32),
//			.DATA_WIDTH(32)
//			) u_i0_bfm (
//			.clock(						clock),
//			.reset(						reset),
//			`WB_CONNECT(, duti0_)
//			);	
//	
//	wb_target_bfm #(
//			.ADDR_WIDTH(32),
//			.DATA_WIDTH(32)
//			) u_i1_bfm (
//			.clock(						clock),
//			.reset(						reset),
//			`WB_CONNECT(, duti1_)
//			);	


endmodule


