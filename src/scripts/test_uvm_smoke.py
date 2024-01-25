
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

