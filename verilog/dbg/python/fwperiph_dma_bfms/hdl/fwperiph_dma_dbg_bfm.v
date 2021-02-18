
/****************************************************************************
 * fwperiph_dma_dbg_bfm.v
 ****************************************************************************/

  
/**
 * Module: fwperiph_dma_dbg_bfm
 * 
 * TODO: Add module documentation
 */
module fwperiph_dma_dbg_bfm #(
		parameter ch_count=1
		) (
		input				clock,
		input[31:0]			adr,
		input[31:0]			dat_w,
		input				we,
		input[4:0]          ch_sel,
		input               dma_busy,
		input				dma_done_all
		);

	fwperiph_dma_dbg_ch ch00();
	fwperiph_dma_dbg_ch ch01();
	fwperiph_dma_dbg_ch ch02();
	fwperiph_dma_dbg_ch ch03();
	fwperiph_dma_dbg_ch ch04();
	fwperiph_dma_dbg_ch ch05();
	fwperiph_dma_dbg_ch ch06();
	fwperiph_dma_dbg_ch ch07();
	fwperiph_dma_dbg_ch ch08();
	fwperiph_dma_dbg_ch ch09();
	fwperiph_dma_dbg_ch ch10();
	fwperiph_dma_dbg_ch ch11();
	fwperiph_dma_dbg_ch ch12();
	fwperiph_dma_dbg_ch ch13();
	fwperiph_dma_dbg_ch ch14();
	fwperiph_dma_dbg_ch ch15();

	// Track which channel is busy
	reg      is_busy = 0;
	reg[1:0] idle_cnt = {2{1'b0}};
	reg[4:0] last_ch_sel = {5{1'b0}};
	
	always @(posedge clock) begin
		if (is_busy || dma_busy) begin
			if (!dma_busy) begin
				// Determine whether we are going idle
				if (idle_cnt == 2'b11) begin
					is_busy <= 0;
					idle_cnt <= {2{1'b0}};
					// TODO: signal BFM
				end else begin
					idle_cnt <= idle_cnt + 1;
					is_busy <= 1;
				end
			end else if (dma_done_all) begin
				// Transfer is complete
				_notify_complete(ch_sel);
				idle_cnt <= {2{1'b0}};
				is_busy <= 0;
			end else begin
				idle_cnt <= {2{1'b0}};
				is_busy <= 1;
				if (ch_sel != last_ch_sel) begin
					// New channel
					last_ch_sel <= ch_sel;
				end
			end
		end
	end
	assign ch00.active = (is_busy && last_ch_sel == 0);
	assign ch01.active = (is_busy && last_ch_sel == 1);
	assign ch02.active = (is_busy && last_ch_sel == 2);
	assign ch03.active = (is_busy && last_ch_sel == 3);
	assign ch04.active = (is_busy && last_ch_sel == 4);
	assign ch05.active = (is_busy && last_ch_sel == 5);
	assign ch06.active = (is_busy && last_ch_sel == 6);
	assign ch07.active = (is_busy && last_ch_sel == 7);
	
	task _clr_src_s(input reg[7:0] id);
		case (id)
			0: ch00.src = {32*8{1'b0}};
			1: ch01.src = {32*8{1'b0}};
			2: ch02.src = {32*8{1'b0}};
			3: ch03.src = {32*8{1'b0}};
			4: ch04.src = {32*8{1'b0}};
			5: ch05.src = {32*8{1'b0}};
			6: ch06.src = {32*8{1'b0}};
			7: ch07.src = {32*8{1'b0}};
			8: ch08.src = {32*8{1'b0}};
			9: ch09.src = {32*8{1'b0}};
			10: ch10.src = {32*8{1'b0}};
			11: ch11.src = {32*8{1'b0}};
			12: ch12.src = {32*8{1'b0}};
			13: ch13.src = {32*8{1'b0}};
			14: ch14.src = {32*8{1'b0}};
			15: ch15.src = {32*8{1'b0}};
		endcase
	endtask
	
	task _set_src_c(input reg[7:0] channel, input reg[7:0] idx, input reg[7:0] ch);
	begin
		idx = (32 - idx - 1);
		case (channel)
			0: ch00.src = ((ch00.src & ~('hff << 8*idx)) | (ch << 8*idx));
			1: ch01.src = ((ch01.src & ~('hff << 8*idx)) | (ch << 8*idx));
			2: ch02.src = ((ch02.src & ~('hff << 8*idx)) | (ch << 8*idx));
			3: ch03.src = ((ch03.src & ~('hff << 8*idx)) | (ch << 8*idx));
			4: ch04.src = ((ch04.src & ~('hff << 8*idx)) | (ch << 8*idx));
			5: ch05.src = ((ch05.src & ~('hff << 8*idx)) | (ch << 8*idx));
			6: ch06.src = ((ch06.src & ~('hff << 8*idx)) | (ch << 8*idx));
			7: ch07.src = ((ch07.src & ~('hff << 8*idx)) | (ch << 8*idx));
			8: ch08.src = ((ch08.src & ~('hff << 8*idx)) | (ch << 8*idx));
			9: ch09.src = ((ch09.src & ~('hff << 8*idx)) | (ch << 8*idx));
			10: ch10.src = ((ch10.src & ~('hff << 8*idx)) | (ch << 8*idx));
			11: ch11.src = ((ch11.src & ~('hff << 8*idx)) | (ch << 8*idx));
			12: ch12.src = ((ch12.src & ~('hff << 8*idx)) | (ch << 8*idx));
			13: ch13.src = ((ch13.src & ~('hff << 8*idx)) | (ch << 8*idx));
			14: ch14.src = ((ch14.src & ~('hff << 8*idx)) | (ch << 8*idx));
			15: ch15.src = ((ch15.src & ~('hff << 8*idx)) | (ch << 8*idx));
		endcase
	end
	endtask
	
	task _clr_dst_s(input reg[7:0] id);
		case (id)
			0: ch00.dst = {32*8{1'b0}};
			1: ch01.dst = {32*8{1'b0}};
			2: ch02.dst = {32*8{1'b0}};
			3: ch03.dst = {32*8{1'b0}};
			4: ch04.dst = {32*8{1'b0}};
			5: ch05.dst = {32*8{1'b0}};
			6: ch06.dst = {32*8{1'b0}};
			7: ch07.dst = {32*8{1'b0}};
			8: ch08.dst = {32*8{1'b0}};
			9: ch09.dst = {32*8{1'b0}};
			10: ch10.dst = {32*8{1'b0}};
			11: ch11.dst = {32*8{1'b0}};
			12: ch12.dst = {32*8{1'b0}};
			13: ch13.dst = {32*8{1'b0}};
			14: ch14.dst = {32*8{1'b0}};
			15: ch15.dst = {32*8{1'b0}};
		endcase
	endtask
	
	task _set_dst_c(input reg[7:0] channel, input reg[7:0] idx, input reg[7:0] ch);
		begin
			idx = (32 - idx - 1);
			case (channel)
				0: ch00.dst = ((ch00.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				1: ch01.dst = ((ch01.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				2: ch02.dst = ((ch02.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				3: ch03.dst = ((ch03.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				4: ch04.dst = ((ch04.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				5: ch05.dst = ((ch05.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				6: ch06.dst = ((ch06.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				7: ch07.dst = ((ch07.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				8: ch08.dst = ((ch08.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				9: ch09.dst = ((ch09.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				10: ch10.dst = ((ch10.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				11: ch11.dst = ((ch11.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				12: ch12.dst = ((ch12.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				13: ch13.dst = ((ch13.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				14: ch14.dst = ((ch14.dst & ~('hff << 8*idx)) | (ch << 8*idx));
				15: ch15.dst = ((ch15.dst & ~('hff << 8*idx)) | (ch << 8*idx));
			endcase
		end
	endtask	

	task _clr_sz_s(input reg[7:0] id);
		case (id)
			0: ch00.sz = {32*8{1'b0}};
			1: ch01.sz = {32*8{1'b0}};
			2: ch02.sz = {32*8{1'b0}};
			3: ch03.sz = {32*8{1'b0}};
			4: ch04.sz = {32*8{1'b0}};
			5: ch05.sz = {32*8{1'b0}};
			6: ch06.sz = {32*8{1'b0}};
			7: ch07.sz = {32*8{1'b0}};
			8: ch08.sz = {32*8{1'b0}};
			9: ch09.sz = {32*8{1'b0}};
			10: ch10.sz = {32*8{1'b0}};
			11: ch11.sz = {32*8{1'b0}};
			12: ch12.sz = {32*8{1'b0}};
			13: ch13.sz = {32*8{1'b0}};
			14: ch14.sz = {32*8{1'b0}};
			15: ch15.sz = {32*8{1'b0}};
		endcase
	endtask
	
	task _set_sz_c(input reg[7:0] channel, input reg[7:0] idx, input reg[7:0] ch);
		begin
			idx = (32 - idx - 1);
			case (channel)
				0: ch00.sz = ((ch00.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				1: ch01.sz = ((ch01.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				2: ch02.sz = ((ch02.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				3: ch03.sz = ((ch03.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				4: ch04.sz = ((ch04.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				5: ch05.sz = ((ch05.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				6: ch06.sz = ((ch06.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				7: ch07.sz = ((ch07.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				8: ch08.sz = ((ch08.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				9: ch09.sz = ((ch09.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				10: ch10.sz = ((ch10.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				11: ch11.sz = ((ch11.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				12: ch12.sz = ((ch12.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				13: ch13.sz = ((ch13.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				14: ch14.sz = ((ch14.sz & ~('hff << 8*idx)) | (ch << 8*idx));
				15: ch15.sz = ((ch15.sz & ~('hff << 8*idx)) | (ch << 8*idx));
			endcase
		end
	endtask	
	
	always @(posedge clock) begin
		if (we) begin
			_reg_write(adr, dat_w);
		end
	end
	
	task init;
	begin
		_set_parameters(ch_count);
	end
	endtask
	
    // Auto-generated code to implement the BFM API
`ifdef PYBFMS_GEN
${pybfms_api_impl}
`endif
	
endmodule

module fwperiph_dma_dbg_ch(
		);
	reg[32*8-1:0]			src = {32*8{1'b0}};
	reg[32*8-1:0]			dst = {32*8{1'b0}};
	reg[32*8-1:0]			sz  = {32*8{1'b0}};
	wire					active;
	
endmodule


