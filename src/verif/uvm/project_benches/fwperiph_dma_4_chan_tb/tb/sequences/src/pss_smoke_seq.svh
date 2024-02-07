
class PSSRegAdapterMemIF #(type BASE_T=uvm_object) extends BASE_T;
    function new(string name = "" );
        super.new(name);
    endfunction

    virtual task read32(
        output int unsigned retval,
        input longint unsigned hndl);
        $display("read32 0x%08h", hndl);
        retval = 5;
    endtask

    virtual task write32(longint unsigned hndl, int unsigned data);
        $display("write32 0x%08h 0x%08x", hndl, data);
    endtask
endclass

class pss_smoke_seq extends RegAdapterMemIF #(
    PssBaseIF #(
        .BASE_T(fwperiph_dma_4_chan_tb_bench_sequence_base)));
  `uvm_object_utils( pss_smoke_seq );


  function new(string name = "" );
    super.new(name);
  endfunction

  task body();
    fwvip_wb2reg_adapter          reg_adapter;
    Actor actor;

    reg_adapter = new();
    m_reg_adapter = reg_adapter;
    m_reg_seqr = top_configuration.reg_init_config.sequencer;

    reg_init_config.wait_for_reset();

//    zuspec_enableDebug(1);
    actor = new("pss_top", "pss_top::Entry", '{this});
    
    actor.run();
  endtask

  virtual task doit();
    $display("doit");
  endtask

endclass