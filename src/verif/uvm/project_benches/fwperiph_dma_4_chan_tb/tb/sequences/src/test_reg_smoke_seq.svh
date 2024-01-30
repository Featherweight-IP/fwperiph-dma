//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains the top level sequence used in  example_derived_test.
// It is an example of a sequence that is extended from %(benchName)_bench_sequence_base
// and can override %(benchName)_bench_sequence_base.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//

class uvm_reg_seq_base extends uvm_sequence_base;

  `uvm_object_utils(uvm_reg_seq_base)


  function new(string name = "uvm_reg_seq_base");
    super.new(name);
  endfunction

endclass

class test_reg_smoke_seq extends fwperiph_dma_4_chan_tb_bench_sequence_base;

  `uvm_object_utils( test_reg_smoke_seq );

  function new(string name = "" );
    super.new(name);
  endfunction


  task body();
    uvm_status_e status;
    uvm_reg_data_t data;
    
    reg_init_config.wait_for_reset();

    $display("Hello");
    fwperiph_dma_4_chan_rm.csr.read(status, data);
    fwperiph_dma_4_chan_rm.int_msk_a.read(status, data);
    fwperiph_dma_4_chan_rm.int_msk_b.read(status, data);
    data = 32'hFFFF_FFFF;
    fwperiph_dma_4_chan_rm.int_msk_a.write(status, data);
    fwperiph_dma_4_chan_rm.int_msk_a.read(status, data);

    begin
        uvm_reg_bus_op rw;
        uvm_sequence_item item;
        uvm_sequencer_base seqr = fwperiph_dma_4_chan_rm.default_map.get_sequencer();
        uvm_reg_adapter adapter = fwperiph_dma_4_chan_rm.default_map.get_adapter();
        uvm_reg_seq_base reg_seq = new();

//        uvm_sequence_base parent_seq = fwperiph_dma_4_chan_rm.get_parent_sequence();
        rw.addr = 32'h1000_0000;
        rw.kind = UVM_WRITE;
        rw.data = 32'h55aaeeff;
        rw.n_bits = 32;

        item = adapter.reg2bus(rw);
        reg_seq.set_sequencer(seqr);
        item.set_parent_sequence(reg_seq);
        reg_seq.start_item(item);
        reg_seq.finish_item(item);

        rw.addr = 32'h1000_0000;
        rw.kind = UVM_READ;
        rw.data = 32'h55aaeeff;
        rw.n_bits = 32;

        item = adapter.reg2bus(rw);
        reg_seq.set_sequencer(seqr);
        item.set_parent_sequence(reg_seq);
        reg_seq.start_item(item);
        reg_seq.finish_item(item);
    end
    #100us;
  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

