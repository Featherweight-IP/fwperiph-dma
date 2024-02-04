
class pss_smoke_seq extends PssBaseIF #(.BASE_T(fwperiph_dma_4_chan_tb_bench_sequence_base));

  `uvm_object_utils( pss_smoke_seq );

  class MethodClosure extends MethodBridge;
    pss_smoke_seq       target;

    typedef enum {
        Func_doit,
        Func_read32,
        Func_read16,
        Func_read8,
        Func_write32,
        Func_write16,
        Func_write8
    } target_func_e;

    function new(pss_smoke_seq target);
        this.target = target;
    endfunction

    virtual function void init(ActorCore actor);
        super.init(actor);

        void'(actor.registerFunctionId("doit", Func_doit));
        void'(actor.registerFunctionId("addr_reg_pkg::read32", Func_read32));
        void'(actor.registerFunctionId("addr_reg_pkg::read16", Func_read16));
        void'(actor.registerFunctionId("addr_reg_pkg::read8", Func_read8));
        void'(actor.registerFunctionId("addr_reg_pkg::write32", Func_write32));
        void'(actor.registerFunctionId("addr_reg_pkg::write16", Func_write16));
        void'(actor.registerFunctionId("addr_reg_pkg::write8", Func_write8));
    endfunction

    virtual task invokeFuncTarget(
        EvalThread      thread,
        int             func_id,
        ValRef          params[]);
        case (func_id)
        Func_doit: begin
            target.doit();
            thread.setVoidResult();
        end
        Func_read32: begin
        end
        Func_write32: begin
            longint unsigned addr = params[0].get_uint32();
            int unsigned data = params[1].get_uint32();
            target.write32(addr, data);
            thread.setVoidResult();
        end
        default: begin
            $display("FATAL: func-id %0d not implemented", func_id);
            $finish;
        end
        endcase
    endtask

    virtual function void invokeFuncSolve(
        EvalThread      thread,
        int             func_id,
        ValRef          params[]);
        $display("FATAL: zuspec::Backend::invokeFuncSolve not implemented");
        $finish;
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

  virtual task doit();
    $display("doit");
  endtask

  virtual task write32(longint unsigned hndl, int unsigned data);
    $display("write32: 0x%08h 0x%08h", hndl, data);
  endtask

endclass