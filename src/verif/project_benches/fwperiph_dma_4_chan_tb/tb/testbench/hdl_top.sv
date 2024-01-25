//----------------------------------------------------------------------
// Created with uvmf_gen version 2023.4
//----------------------------------------------------------------------
// pragma uvmf custom header begin
// pragma uvmf custom header end
//----------------------------------------------------------------------
//----------------------------------------------------------------------                     
//               
// Description: This top level module instantiates all synthesizable
//    static content.  This and tb_top.sv are the two top level modules
//    of the simulation.  
//
//    This module instantiates the following:
//        DUT: The Design Under Test
//        Interfaces:  Signal bundles that contain signals connected to DUT
//        Driver BFM's: BFM's that actively drive interface signals
//        Monitor BFM's: BFM's that passively monitor interface signals
//
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//

module hdl_top;

import fwperiph_dma_4_chan_tb_parameters_pkg::*;
import uvmf_base_pkg_hdl::*;

  // pragma attribute hdl_top partition_module_xrtl                                            
// pragma uvmf custom clock_generator begin
  bit clk;
  // Instantiate a clk driver 
  // tbx clkgen
  initial begin
    clk = 0;
    #9ns;
    forever begin
      clk = ~clk;
      #5ns;
    end
  end
// pragma uvmf custom clock_generator end

// pragma uvmf custom reset_generator begin
  bit rst;
  // Instantiate a rst driver
  // tbx clkgen
  initial begin
    rst = 0; 
    #200ns;
    rst =  1; 
  end
// pragma uvmf custom reset_generator end

  // pragma uvmf custom module_item_additional begin
  // pragma uvmf custom module_item_additional end

  // Instantiate the signal bundle, monitor bfm and driver bfm for each interface.
  // The signal bundle, _if, contains signals to be connected to the DUT.
  // The monitor, monitor_bfm, observes the bus, _if, and captures transactions.
  // The driver, driver_bfm, drives transactions onto the bus, _if.
  fwvip_wb_if  reg_init_bus(
     // pragma uvmf custom reg_init_bus_connections begin
     .clock(clk), .reset(rst)
     // pragma uvmf custom reg_init_bus_connections end
     );
  fwvip_wb_if  mem_init_bus(
     // pragma uvmf custom mem_init_bus_connections begin
     .clock(clk), .reset(rst)
     // pragma uvmf custom mem_init_bus_connections end
     );
  fwvip_wb_monitor_bfm  reg_init_mon_bfm(reg_init_bus);
  fwvip_wb_monitor_bfm  mem_init_mon_bfm(mem_init_bus);
  fwvip_wb_driver_bfm  reg_init_drv_bfm(reg_init_bus);
  fwvip_wb_driver_bfm  mem_init_drv_bfm(mem_init_bus);

  // pragma uvmf custom dut_instantiation begin
  // UVMF_CHANGE_ME : Add DUT and connect to signals in _bus interfaces listed above
  // Instantiate your DUT here
  // ...
  // pragma uvmf custom dut_instantiation end

  initial begin      // tbx vif_binding_block 
    import uvm_pkg::uvm_config_db;
    // The monitor_bfm and driver_bfm for each interface is placed into the uvm_config_db.
    // They are placed into the uvm_config_db using the string names defined in the parameters package.
    // The string names are passed to the agent configurations by test_top through the top level configuration.
    // They are retrieved by the agents configuration class for use by the agent.
    uvm_config_db #( virtual fwvip_wb_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , reg_init_BFM , reg_init_mon_bfm ); 
    uvm_config_db #( virtual fwvip_wb_monitor_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , mem_init_BFM , mem_init_mon_bfm ); 
    uvm_config_db #( virtual fwvip_wb_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , reg_init_BFM , reg_init_drv_bfm  );
    uvm_config_db #( virtual fwvip_wb_driver_bfm  )::set( null , UVMF_VIRTUAL_INTERFACES , mem_init_BFM , mem_init_drv_bfm  );
  end

endmodule

// pragma uvmf custom external begin
// pragma uvmf custom external end

