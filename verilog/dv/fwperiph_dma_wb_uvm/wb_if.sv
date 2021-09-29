/****************************************************************************
 * wb_if.sv
 ****************************************************************************/

/**
 * Interface: wb_if
 * 
 * TODO: Add interface documentation
 */
interface wb_if #(
		parameter int WB_ADDR_WIDTH = 32,
		parameter int WB_TGA_WIDTH = 1,
		parameter int WB_DATA_WIDTH = 32,
		parameter int WB_TGD_WIDTH = 1,
		parameter int WB_TGC_WIDTH = 1
		);
	
	reg[(WB_ADDR_WIDTH-1):0]			ADR;
	reg[(WB_TGA_WIDTH-1):0]				TGA;
	reg[2:0]							CTI;
	reg[1:0]							BTE;
	reg[(WB_DATA_WIDTH-1):0]			DAT_W;
	reg[(WB_TGD_WIDTH-1):0]				TGD_W;
	reg[(WB_DATA_WIDTH-1):0]			DAT_R;
	reg[(WB_TGD_WIDTH-1):0]				TGD_R;
	reg									CYC;
	reg[(WB_TGC_WIDTH-1):0]				TGC;
	reg									ERR;
	reg[(WB_DATA_WIDTH/8)-1:0]			SEL;
	reg									STB;
	reg									ACK;
	reg									WE;

	modport master(
			output		ADR,
			output		TGA,
			output		CTI,
			output		BTE,
			output		DAT_W,
			output		TGD_W,
			input		DAT_R,
			output		TGD_R,
			output		CYC,
			output		TGC,
			input		ERR,
			output		SEL,
			output		STB,
			input		ACK,
			output		WE);
	
	modport slave(
			input		ADR,
			input		TGA,
			input		CTI,
			input		BTE,
			input		DAT_W,
			input		TGD_W,
			output		DAT_R,
			output		TGD_R,
			input		CYC,
			input		TGC,
			output		ERR,
			input		SEL,
			input		STB,
			output		ACK,
			input		WE);
		
	modport monitor(
			input		ADR,
			input		TGA,
			input		CTI,
			input		BTE,
			input		DAT_W,
			input		TGD_W,
			input		DAT_R,
			input		TGD_R,
			input		CYC,
			input		TGC,
			input		ERR,
			input		SEL,
			input		STB,
			input		ACK,
			input		WE);
			

endinterface

