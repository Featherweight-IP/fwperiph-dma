
`include "wishbone_macros.svh"
`include "generic_sram_byte_en_macros.svh"

module fwperiph_dma_4_chan_tb (
    input           clock,
    input           reset,
    `WB_TARGET_PORT(reg_, 32, 32),
    `WB_TARGET_PORT(mem_, 32, 32)
);

    `WB_WIRES_ARR(dut2ic_, 32, 32, 4);
    `WB_WIRES_ARR(ic2targ_, 32, 32, 2);
    `WB_ASSIGN_WIRES2ARR(dut2ic_, reg_, 2, 32, 32);
    `WB_ASSIGN_WIRES2ARR(dut2ic_, mem_, 3, 32, 32);

    fwperiph_dma_wb #(
        .ch_count(4)
    ) u_dut (
        .clock(clock),
        .reset(reset),
        `WB_CONNECT_ARR(rt_, ic2targ_, 0, 32, 32),
        `WB_CONNECT_ARR(i0_, dut2ic_, 0, 32, 32),
        `WB_CONNECT_ARR(i1_, dut2ic_, 1, 32, 32)
    );

    wb_interconnect_NxN #(
        .N_INITIATORS(4),
        .N_TARGETS(2),
        .T_ADR_MASK({
            32'hF000_0000,
            32'h1000_0000}),
        .T_ADR({
            32'h0000_0000,
            32'h1000_0000})
    ) u_ic (
        .clock(clock),
        .reset(reset),
        `WB_CONNECT( , dut2ic_),
        `WB_CONNECT(t, ic2targ_)
    );

    `GENERIC_SRAM_BYTE_EN_WIRES(ctrl2ram_, 16, 32);

    fw_wishbone_sram_ctrl_single #(
        .ADR_WIDTH(32),
        .DAT_WIDTH(32)) u_sram_ctrl (
        .clock(clock),
        .reset(reset),
        `WB_CONNECT_ARR(t_, ic2targ_, 1, 32, 32),
        `GENERIC_SRAM_BYTE_EN_CONNECT(i_, ctrl2ram_)
    );

    localparam MEM_BITS = 14;
    reg[7:0]            mem0[(1 << MEM_BITS)-1:0];
    reg[7:0]            mem1[(1 << MEM_BITS)-1:0];
    reg[7:0]            mem2[(1 << MEM_BITS)-1:0];
    reg[7:0]            mem3[(1 << MEM_BITS)-1:0];

    wire[MEM_BITS-1:0] sram_addr = ctrl2ram_addr;
    assign ctrl2ram_read_data = {
        mem3[sram_addr],
        mem2[sram_addr],
        mem1[sram_addr],
        mem0[sram_addr]
    };
    always @(posedge clock or reset) begin
        if (reset) begin
        end else begin
            if (ctrl2ram_write_en) begin
                if (ctrl2ram_byte_en[3]) begin
                    mem3[sram_addr] <= ctrl2ram_write_data[31:24];
                end
                if (ctrl2ram_byte_en[2]) begin
                    mem2[sram_addr] <= ctrl2ram_write_data[23:16];
                end
                if (ctrl2ram_byte_en[1]) begin
                    mem1[sram_addr] <= ctrl2ram_write_data[15:8];
                end
                if (ctrl2ram_byte_en[0]) begin
                    mem0[sram_addr] <= ctrl2ram_write_data[7:0];
                end
            end
        end
    end

endmodule