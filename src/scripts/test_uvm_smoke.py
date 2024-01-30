
import os
import pytest
from pytest_fv import *
from .util import setup_build_rtl


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
    sim, fs = setup_build_rtl(dirconfig)

    sim.debug = True

    sim.build()

    if not os.path.isdir(dirconfig.rundir()):
        os.makedirs(dirconfig.rundir())
    
    with open(os.path.join(dirconfig.rundir(), "pss_top.pss"), "w") as fp:
        fp.write("""
import std_pkg::*;
import function void doit();
component pss_top {
    action Entry {
        exec post_solve {
            print("Hello World!");
        }
        exec body {
            doit();
        }
    }
}
""")

    args = sim.mkRunArgs(dirconfig.rundir())
    args.plusargs.append("UVM_TESTNAME=test_pss_smoke")
    args.plusargs.append("zuspec.pssfiles=pss_top.pss")
    sim.run(args)

