
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
		input				we
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
	reg						active = 0;
	
endmodule


