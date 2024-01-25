//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//                                          
// DESCRIPTION: This file contains environment level sequences that will
//    be reused from block to top level simulations.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
class fwperiph_dma_4_chan_env_sequence_base #( 
      type CONFIG_T
      ) extends uvmf_virtual_sequence_base #(.CONFIG_T(CONFIG_T));


  `uvm_object_param_utils( fwperiph_dma_4_chan_env_sequence_base #(
                           CONFIG_T
                           ) );

  // Handle to the environments register model
// This handle needs to be set before use.
  fwperiph_dma_map  fwperiph_dma_4_chan_rm;

// This fwperiph_dma_4_chan_env_sequence_base contains a handle to a fwperiph_dma_4_chan_env_configuration object 
// named configuration.  This configuration variable contains a handle to each 
// sequencer within each agent within this environment and any sub-environments.
// The configuration object handle is automatically assigned in the pre_body in the
// base class of this sequence.  The configuration handle is retrieved from the
// virtual sequencer that this sequence is started on.
// Available sequencer handles within the environment configuration:

  // Initiator agent sequencers in fwperiph_dma_4_chan_environment:
    // configuration.reg_init_config.sequencer
    // configuration.mem_init_config.sequencer

  // Responder agent sequencers in fwperiph_dma_4_chan_environment:


    typedef fwvip_wb_random_sequence reg_init_random_sequence_t;
    reg_init_random_sequence_t reg_init_rand_seq;

    typedef fwvip_wb_random_sequence mem_init_random_sequence_t;
    mem_init_random_sequence_t mem_init_rand_seq;


// This example shows how to use the environment sequence base for sub-environments
// It can only be used on environments generated with UVMF_2022.3 and later.
// Environment sequences generated with UVMF_2022.1 and earlier do not have the required 
//    environment level virtual sequencer


  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  function new(string name = "" );
    super.new(name);
    reg_init_rand_seq = reg_init_random_sequence_t::type_id::create("reg_init_rand_seq");
    mem_init_rand_seq = mem_init_random_sequence_t::type_id::create("mem_init_rand_seq");


  endfunction

  virtual task body();

  // Handle to the environments register model
// This handle needs to be set before use.
  fwperiph_dma_4_chan_rm = configuration.fwperiph_dma_4_chan_rm ;

    if ( configuration.reg_init_config.sequencer != null )
       repeat (25) reg_init_rand_seq.start(configuration.reg_init_config.sequencer);
    if ( configuration.mem_init_config.sequencer != null )
       repeat (25) mem_init_rand_seq.start(configuration.mem_init_config.sequencer);


  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

