/****************************************************************************
 * wb_monitor_bfm.sv
 ****************************************************************************/

/**
 * Interface: wb_monitor_bfm
 * 
 * TODO: Add interface documentation
 */
interface wb_monitor_bfm #(
		parameter int		WB_ADDR_WIDTH = 32,
		parameter int		WB_DATA_WIDTH = 32
		) (
		input				clk,
		input				rstn,
		wb_if.monitor		monitor
		);
	
	always @(posedge clk) begin
		if (rstn == 1) begin
			if (monitor.CYC && monitor.STB && monitor.ACK) begin
				$display("%m: %0t %0s: 'h%08h 'h%08h", $time,
						(monitor.WE)?"WRITE":"READ", monitor.ADR, 
						(monitor.WE)?monitor.DAT_W:monitor.DAT_R);
			end
		end 
	end


endinterface


