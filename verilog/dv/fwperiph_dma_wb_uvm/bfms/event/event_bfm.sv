/****************************************************************************
 * event_bfm.sv
 ****************************************************************************/

/**
 * Module: event_bfm
 * 
 * TODO: Add module documentation
 */
module event_bfm #(parameter int WIDTH=32) (
		input				clk,
		input				rst,
		input[WIDTH-1:0]	ev
		);
	
	event_bfm_core		u_core(
			.clk(clk),
			.rst(rst)
			);

	generate
		if (WIDTH < 64) begin
			assign u_core.ev = {{(64-WIDTH){1'b0}}, ev};
		end else begin
			assign u_core.ev = ev;
		end
	endgenerate


endmodule

interface event_bfm_core(
		input				clk,
		input				rst);
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	import event_api_pkg::*;
`endif /* HAVE_HDL_VIRTUAL_INTERFACE */
	
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
	event_api			m_api;
`else
	int unsigned		m_id;
	
	import "DPI-C" context function int unsigned event_bfm_register(string path);
	
	initial begin
		m_id = event_bfm_register($sformatf("%m"));
	end
`endif /* HAVE_HDL_VIRTUAL_INTERFACE */

	reg[63:0]			ev_r;
	wire[63:0]			ev;
	reg					reset_begin = 0;
	
	always @(posedge clk) begin
		if (rst == 1) begin
			ev_r <= 0;
			reset_begin <= 1;
		end else begin
			reset_begin <= 0;
			if (reset_begin || ev != ev_r) begin
				event_update();
				ev_r <= ev;
			end
		end
	end
	
`ifndef HAVE_HDL_VIRTUAL_INTERFACE
	import "DPI-C" task event_bfm_event_update(int unsigned id, longint unsigned v);
`endif
	
	task event_update();
`ifdef HAVE_HDL_VIRTUAL_INTERFACE
		m_api.event_update(ev);
`else
		event_bfm_event_update(m_id, ev);
`endif
	endtask
	
endinterface


