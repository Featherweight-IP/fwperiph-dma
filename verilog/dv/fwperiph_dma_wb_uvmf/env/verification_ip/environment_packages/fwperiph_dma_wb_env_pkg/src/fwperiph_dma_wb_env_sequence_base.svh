//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.3
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
class fwperiph_dma_wb_env_sequence_base #( 
      type CONFIG_T
      ) extends uvmf_virtual_sequence_base #(.CONFIG_T(CONFIG_T));


  `uvm_object_param_utils( fwperiph_dma_wb_env_sequence_base #(
                           CONFIG_T
                           ) );

  
// This fwperiph_dma_wb_env_sequence_base contains a handle to a fwperiph_dma_wb_env_configuration object 
// named configuration.  This configuration variable contains a handle to each 
// sequencer within each agent within this environment and any sub-environments.
// The configuration object handle is automatically assigned in the pre_body in the
// base class of this sequence.  The configuration handle is retrieved from the
// virtual sequencer that this sequence is started on.
// Available sequencer handles within the environment configuration:

  // Initiator agent sequencers in fwperiph_dma_wb_environment:
    // configuration.reg_initiator_config.sequencer

  // Responder agent sequencers in fwperiph_dma_wb_environment:


    typedef wb_random_sequence reg_initiator_random_sequence_t;
    reg_initiator_random_sequence_t reg_initiator_rand_seq;


// This example shows how to use the environment sequence base for sub-environments
// It can only be used on environments generated with UVMF_2022.3 and later.
// Environment sequences generated with UVMF_2022.1 and earlier do not have the required 
//    environment level virtual sequencer


  // pragma uvmf custom class_item_additional begin
  // pragma uvmf custom class_item_additional end
  
  function new(string name = "" );
    super.new(name);
    reg_initiator_rand_seq = reg_initiator_random_sequence_t::type_id::create("reg_initiator_rand_seq");


  endfunction

  virtual task body();

  
    if ( configuration.reg_initiator_config.sequencer != null )
       repeat (25) reg_initiator_rand_seq.start(configuration.reg_initiator_config.sequencer);


  endtask

endclass

// pragma uvmf custom external begin
// pragma uvmf custom external end

