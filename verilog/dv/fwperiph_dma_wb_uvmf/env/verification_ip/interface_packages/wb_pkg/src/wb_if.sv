//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.3
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//     
// DESCRIPTION: This interface contains the wb interface signals.
//      It is instantiated once per wb bus.  Bus Functional Models, 
//      BFM's named wb_driver_bfm, are used to drive signals on the bus.
//      BFM's named wb_monitor_bfm are used to monitor signals on the 
//      bus. This interface signal bundle is passed in the port list of
//      the BFM in order to give the BFM access to the signals in this
//      interface.
//
//----------------------------------------------------------------------
//----------------------------------------------------------------------
//
// This template can be used to connect a DUT to these signals
//
// .dut_signal_port(wb_bus.addr), // Agent output 

import uvmf_base_pkg_hdl::*;
import wb_pkg_hdl::*;

interface  wb_if 

  (
  input tri clock, 
  input tri reset,
  inout tri [31:0] addr
  );

modport monitor_port 
  (
  input clock,
  input reset,
  input addr
  );

modport initiator_port 
  (
  input clock,
  input reset,
  output addr
  );

modport responder_port 
  (
  input clock,
  input reset,  
  input addr
  );
  

// pragma uvmf custom interface_item_additional begin
// pragma uvmf custom interface_item_additional end

endinterface

// pragma uvmf custom external begin
// pragma uvmf custom external end

