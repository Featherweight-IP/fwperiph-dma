
class pss_smoke_seq extends fwperiph_dma_4_chan_tb_bench_sequence_base;

  `uvm_object_utils( pss_smoke_seq );

  class MethodClosure extends MethodBridge;
    pss_smoke_seq       target;

    function new(pss_smoke_seq target);
        this.target = target;
    endfunction

    virtual function void init(ActorCore actor);
        super.init(actor);

        actor.registerFunctionId("doit", 1);
    endfunction

  endclass

  function new(string name = "" );
    super.new(name);
  endfunction

  task body();
    MethodClosure closure = new(this);
    ActorCore act;
//    zuspec_enableDebug(1);
    act = new("pss_top", "pss_top::Entry", closure);
    
    act.run();
  endtask

endclass