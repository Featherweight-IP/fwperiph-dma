//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// Description: This file contains the top level and utility sequences
//     used by test_top. It can be extended to create derivative top
//     level sequences.
//
//----------------------------------------------------------------------
//
//----------------------------------------------------------------------
//


typedef fwperiph_dma_4_chan_env_configuration  fwperiph_dma_4_chan_env_configuration_t;

class fwperiph_dma_4_chan_tb_bench_sequence_base extends uvmf_sequence_base #(uvm_sequence_item);

  `uvm_object_utils( fwperiph_dma_4_chan_tb_bench_sequence_base );

  // pragma uvmf custom sequences begin

// This example shows how to use the environment sequence base
// It can only be used on environments generated with UVMF_2022.3 and later.
// Environment sequences generated with UVMF_2022.1 and earlier do not have the required 
//    environment level virtual sequencer
// typedef fwperiph_dma_4_chan_env_sequence_base #(
//         .CONFIG_T(fwperiph_dma_4_chan_env_configuration_t)// 
//         )
//         fwperiph_dma_4_chan_env_sequence_base_t;
// rand fwperiph_dma_4_chan_env_sequence_base_t fwperiph_dma_4_chan_env_seq;



  // UVMF_CHANGE_ME : Instantiate, construct, and start sequences as needed to create stimulus scenarios.
  // Instantiate sequences here
  typedef fwvip_wb_random_sequence  reg_init_random_seq_t;
  reg_init_random_seq_t reg_init_random_seq;
  typedef fwvip_wb_random_sequence  mem_init_random_seq_t;
  mem_init_random_seq_t mem_init_random_seq;
  // pragma uvmf custom sequences end

  // Sequencer handles for each active interface in the environment
  typedef fwvip_wb_transaction  reg_init_transaction_t;
  uvm_sequencer #(reg_init_transaction_t)  reg_init_sequencer; 
  typedef fwvip_wb_transaction  mem_init_transaction_t;
  uvm_sequencer #(mem_init_transaction_t)  mem_init_sequencer; 


  // Top level environment configuration handle
  fwperiph_dma_4_chan_env_configuration_t top_configuration;

  // Configuration handles to access interface BFM's
  fwvip_wb_configuration  reg_init_config;
  fwvip_wb_configuration  mem_init_config;
  // Local handle to register model for convenience
  fwperiph_dma_map fwperiph_dma_4_chan_rm;
  uvm_status_e status;

  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end

  // ****************************************************************************
  function new( string name = "" );
    super.new( name );
    // Retrieve the configuration handles from the uvm_config_db

    // Retrieve top level configuration handle
    if ( !uvm_config_db#(fwperiph_dma_4_chan_env_configuration_t)::get(null,UVMF_CONFIGURATIONS, "TOP_ENV_CONFIG",top_configuration) ) begin
      `uvm_info("CFG", "*** FATAL *** uvm_config_db::get can not find TOP_ENV_CONFIG.  Are you using an older UVMF release than what was used to generate this bench?",UVM_NONE);
      `uvm_fatal("CFG", "uvm_config_db#(fwperiph_dma_4_chan_env_configuration_t)::get cannot find resource TOP_ENV_CONFIG");
    end

    // Retrieve config handles for all agents
    if( !uvm_config_db #( fwvip_wb_configuration )::get( null , UVMF_CONFIGURATIONS , reg_init_BFM , reg_init_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( fwvip_wb_configuration )::get cannot find resource reg_init_BFM" )
    if( !uvm_config_db #( fwvip_wb_configuration )::get( null , UVMF_CONFIGURATIONS , mem_init_BFM , mem_init_config ) ) 
      `uvm_fatal("CFG" , "uvm_config_db #( fwvip_wb_configuration )::get cannot find resource mem_init_BFM" )

    // Assign the sequencer handles from the handles within agent configurations
    reg_init_sequencer = reg_init_config.get_sequencer();
    mem_init_sequencer = mem_init_config.get_sequencer();

    fwperiph_dma_4_chan_rm = top_configuration.fwperiph_dma_4_chan_rm;


    // pragma uvmf custom new begin
    // pragma uvmf custom new end

  endfunction

  // ****************************************************************************
  virtual task body();
    // pragma uvmf custom body begin

    // Construct sequences here

    // fwperiph_dma_4_chan_env_seq = fwperiph_dma_4_chan_env_sequence_base_t::type_id::create("fwperiph_dma_4_chan_env_seq");

    reg_init_random_seq     = reg_init_random_seq_t::type_id::create("reg_init_random_seq");
    mem_init_random_seq     = mem_init_random_seq_t::type_id::create("mem_init_random_seq");
    fork
      reg_init_config.wait_for_reset();
      mem_init_config.wait_for_reset();
    join
    fwperiph_dma_4_chan_rm.reset();
    // Start RESPONDER sequences here
    fork
    join_none
    // Start INITIATOR sequences here
    fork
      repeat (25) reg_init_random_seq.start(reg_init_sequencer);
      repeat (25) mem_init_random_seq.start(mem_init_sequencer);
    join

// fwperiph_dma_4_chan_env_seq.start(top_configuration.vsqr);

    // UVMF_CHANGE_ME : Extend the simulation XXX number of clocks after 
    // the last sequence to allow for the last sequence item to flow 
    // through the design.
    fork
      reg_init_config.wait_for_num_clocks(400);
      mem_init_config.wait_for_num_clocks(400);
    join

    // pragma uvmf custom body end
  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

