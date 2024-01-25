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

class test_reg_smoke_seq extends fwperiph_dma_4_chan_tb_bench_sequence_base;

  `uvm_object_utils( test_reg_smoke_seq );

  function new(string name = "" );
    super.new(name);
  endfunction

  task body();
    $display("Hello");
  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

