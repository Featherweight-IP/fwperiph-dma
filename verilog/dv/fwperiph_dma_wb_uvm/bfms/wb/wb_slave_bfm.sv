/****************************************************************************
 * wb_slave_bfm.sv
 ****************************************************************************/
 
interface wb_slave_bfm_core #(
		parameter int			WB_ADDR_WIDTH=32,
		parameter int			WB_DATA_WIDTH=32
		) (
		input			clk,
		input			rstn);
	
	reg					reset = 0;
	reg					reset_done = 0;
	
	reg[WB_DATA_WIDTH-1:0]			read_data_buf;
	reg[WB_DATA_WIDTH-1:0]			write_data_buf;
	bit								req;
	bit								ack;
	
	reg								ACK_rs;
	reg								ERR_rs;
	reg								ACK_r;
	reg[WB_DATA_WIDTH-1:0]			DAT_rs;
	
	wire							CYC;
	wire							WE;
	reg								WE_rs;
	wire[WB_ADDR_WIDTH-1:0]			ADR;
	reg[WB_ADDR_WIDTH-1:0]			ADR_rs;
	wire[WB_DATA_WIDTH-1:0]			DAT_W;
	wire[WB_DATA_WIDTH-1:0]			DAT_R_rs;
	wire[(WB_DATA_WIDTH/8)-1:0]		SEL;
	reg[(WB_DATA_WIDTH/8)-1:0]		SEL_rs;
	wire							STB;
	
	bit[1:0]						state;
	
	assign DAT_R_rs = read_data_buf;
	
	always @(posedge clk) begin
		if (rstn == 0) begin
			state <= 0;
			req = 0;
			reset <= 1;
			DAT_rs <= 0;
			ACK_rs <= 0;
			ERR_rs <= 0;
		end else begin
			if (reset == 1) begin
				reset_done <= 1;
				reset <= 0;
			end
			case (state)
				0: begin
					if (CYC===1 && STB===1) begin
						req = 1;
						ADR_rs = ADR;
						SEL_rs = SEL;
						WE_rs = WE;
						write_data_buf = DAT_W;
						
						state <= 1;
					end
				end
			
				// Wait for acknowledge from 'other side'
				1: begin
					if (ack == 1) begin
						ACK_rs <= 1;
						state <= 2;
						ack = 0;
					end
				end
				
				2: begin
					ACK_rs <= 0;
					state <= 0;
				end
			endcase
		end
	end

	task wb_slave_bfm_wait_req(
		output longint unsigned		ADR,
		output int unsigned			SEL,
		output byte unsigned		WE
		);
		
//		// Ensure we wait for reset
		while (reset_done == 0) begin
			@(posedge clk);
		end
	
//		// Wait for a request
		do begin
			@(posedge clk);
		end while (req == 0);
		req=0;
		
		ADR = ADR_rs;
		SEL = SEL_rs;
		WE = WE_rs;
	endtask
	
	task wb_slave_bfm_get_data(
		input int unsigned			idx,
		output int unsigned			data);
		data = write_data_buf;
	endtask
	
	task wb_slave_bfm_set_data(
		input int unsigned			idx,
		input int unsigned			data);
		read_data_buf = data;
	endtask
	
	task wb_slave_bfm_ack_req();
		ack = 1;
	endtask
	
endinterface
		
		

/**
 * Interface: wb_slave_bfm
 * 
 * TODO: Add interface documentation
 */
interface wb_slave_bfm #(
		parameter int			WB_ADDR_WIDTH=32,
		parameter int			WB_DATA_WIDTH=32
		) (
		input			clk,
		input			rstn,
		wb_if.slave		slave);

	wb_slave_bfm_core #(
		.WB_ADDR_WIDTH  (WB_ADDR_WIDTH ), 
		.WB_DATA_WIDTH  (WB_DATA_WIDTH )
		) u_core (
		.clk            (clk           ), 
		.rstn           (rstn          ));
	
	assign slave.ACK = u_core.ACK_rs;
	assign slave.DAT_R = u_core.DAT_R_rs;
	assign slave.ERR = u_core.ERR_rs;
	
	assign u_core.CYC = slave.CYC;
	assign u_core.WE = slave.WE;
	assign u_core.ADR = slave.ADR;
	assign u_core.DAT_W = slave.DAT_W;
	assign u_core.SEL = slave.SEL;
	assign u_core.STB = slave.STB;


endinterface


