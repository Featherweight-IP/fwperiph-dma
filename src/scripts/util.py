import os
import pytest
import pytest_fv as ptv
from pytest_fv import FuseSoc, HdlSim, FlowSim
from pytest_fv.exts.test.pss import ExtPSS
import zsp_sv

def setup_build_rtl(dirconfig):
    print("dirconfig: %s" % str(dirconfig))
    scripts_dir = os.path.dirname(os.path.abspath(__file__))
    fwperiph_dma_dir = os.path.abspath(os.path.join(scripts_dir, "../.."))

    flow = FlowSim(dirconfig, "mti")
    
    # pss = ExtPSS.create()
    # pss.pss_core_vlnv = "featherweight-ip::fwperiph_dma.pss.model"
    # pss.pss_vlnv = "uvmf:project_benches:fwperiph_dma_4_chan_tb"
    # pss.apply(flow)

    flow.addFileset("sim", ptv.FSVlnv("uvmf:project_benches:fwperiph_dma_4_chan_tb"))

    sim = flow.sim
    flow.sim.top.update({"hdl_top", "hvl_top"})

    return flow

