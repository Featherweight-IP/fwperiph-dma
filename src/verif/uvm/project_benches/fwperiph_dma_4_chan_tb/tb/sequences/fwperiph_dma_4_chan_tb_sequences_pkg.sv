//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// DESCRIPTION: This package includes all high level sequence classes used 
//     in the environment.  These include utility sequences and top
//     level sequences.
//
// CONTAINS:
//     -<fwperiph_dma_4_chan_tb_sequence_base>
//     -<example_derived_test_sequence>
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//

package fwperiph_dma_4_chan_tb_sequences_pkg;
  import uvm_pkg::*;
  import uvmf_base_pkg::*;
  import fwvip_wb_pkg::*;
  import fwvip_wb_pkg_hdl::*;
  import fwperiph_dma_4_chan_tb_parameters_pkg::*;
  import fwperiph_dma_4_chan_env_pkg::*;
  import fwperiph_dma_ral::*;
  `include "uvm_macros.svh"



  // pragma uvmf custom package_imports_additional begin
  import zuspec::*;
  import pss_api_pkg::*;
  import zuspec_actor_pkg::*;
  import pss_uvm_util::*;
  // pragma uvmf custom package_imports_additional end

  `include "src/fwperiph_dma_4_chan_tb_bench_sequence_base.svh"
  `include "src/register_test_sequence.svh"
  `include "src/example_derived_test_sequence.svh"

  // pragma uvmf custom package_item_additional begin
  `include "src/test_reg_smoke_seq.svh"
  `include "src/pss_smoke_seq.svh"
  // UVMF_CHANGE_ME : When adding new sequences to the src directory
  //    be sure to add the sequence file here so that it will be
  //    compiled as part of the sequence package.  Be sure to place
  //    the new sequence after any base sequences of the new sequence.
  // pragma uvmf custom package_item_additional end

endpackage

// pragma uvmf custom external begin
// pragma uvmf custom external end

