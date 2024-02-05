
import os
import pytest
from pytest_fv import *
from .util import setup_build_rtl
import asyncio



def test_smoke(dirconfig):
    sim, fs = setup_build_rtl(dirconfig)

    sim.debug = True

    sim.build()
    args = sim.mkRunArgs(dirconfig.rundir())
    args.plusargs.append("UVM_TESTNAME=test_top")
    sim.run(args)

def test_reg_smoke(dirconfig):
    sim, fs = setup_build_rtl(dirconfig)

    sim.debug = True

    sim.build()
    args = sim.mkRunArgs(dirconfig.rundir())
    args.plusargs.append("UVM_TESTNAME=test_reg_smoke")
    sim.run(args)

def test_pss_smoke(dirconfig):
    flow = setup_build_rtl(dirconfig)

    flow.sim.debug = True

#    sim.build()
    
    runtest = TaskList("test_pss_smoke")

    runtest.addSubTask(tasks.TaskCreateFile(
        os.path.join(dirconfig.rundir(), "pss_top.pss"), """
import std_pkg::*;
import addr_reg_pkg::*;

import function void doit();
pure component my_regs : reg_group_c {
    reg_c<bit[32]>         r1;
    reg_c<bit[32]>         r2;
                 
    function bit[64] get_offset_of_instance(string name) {
        if (name == "r1") {
            return 0;
        } else if (name == "r2") {
            return 4;
        }
        return 0xFFFF_FFFF_FFFF_FFFF;
    }
    function bit[64] get_offset_of_instance_array(string name, int index) {
        return 0xFFFF_FFFF_FFFF_FFFF;
    }
}

component pss_top {
    transparent_addr_space_c<>      aspace;
    addr_handle_t                   base_h;
    my_regs                         regs;
                 
    exec init_down {
        transparent_addr_region_s<>  region;
        region.addr= 0x0000;
        region.size = 0x1000;
        base_h = aspace.add_nonallocatable_region(region);
        regs.set_handle(base_h);
    }

    action Entry {
        exec post_solve {
            print("Hello World!");
        }
        exec body {
            doit();
            write32(comp.base_h, 1);
            comp.regs.r1.write_val(2);
            comp.regs.r2.w/project/fun/featherweight-ip/fwperiph-dma-uvmf/packages/zuspec-be-swrite_val(3);
        }
    }
}
"""))

    args = flow.sim.mkRunArgs(dirconfig.rundir())
    args.plusargs.append("UVM_TESTNAME=test_pss_smoke")
#    args.plusargs.append("zuspec.pssfiles=pss_top.pss")
    args.plusargs.append("zuspec.debug=1")
    runtest.addSubTask(flow.sim.mkRunTask(args))
    flow.addTaskToPhase("run.main", runtest)

    loop = asyncio.new_event_loop()
    loop.run_until_complete(flow.run())

