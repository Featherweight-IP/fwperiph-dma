import os
import pytest
from pytest_fv import FuseSoc, HdlSim

def setup_build_rtl(dirconfig):
    print("dirconfig: %s" % str(dirconfig))
    scripts_dir = os.path.dirname(os.path.abspath(__file__))
    fwperiph_dma_dir = os.path.abspath(os.path.join(scripts_dir, "../.."))
    fs = FuseSoc()
    fs.add_library(
        os.path.join(fwperiph_dma_dir, "packages/fwvip-wb/src/vip"))
    fs.add_library(
        os.path.join(fwperiph_dma_dir, "packages/uvmf-core/src/uvmf/share/uvmf_base_pkg"))
    fs.add_library(
        os.path.join(fwperiph_dma_dir, "packages/fwprotocol-defs"))
    fs.add_library(
        os.path.join(fwperiph_dma_dir, "packages/fw-wishbone-interconnect"))
    fs.add_library(
        os.path.join(fwperiph_dma_dir, "src/rtl"))
    fs.add_library(
        os.path.join(fwperiph_dma_dir, "src/verif/uvm"))
    fs.add_library(
        os.path.join(fwperiph_dma_dir, "src/verif/tb"))

    sim = HdlSim.create(dirconfig.builddir(), "mti")
    sim.addFiles(
        fs.getFiles("uvmf:project_benches:fwperiph_dma_4_chan_tb"),
        {'sv-uvm': True})
    sim.top.add("hdl_top")
    sim.top.add("hvl_top")

    return (sim, fs)

