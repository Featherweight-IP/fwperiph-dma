#!/usr/bin/env python3
import os
import subprocess

rdl_dir = os.path.dirname(os.path.abspath(__file__))
verif_dir = os.path.abspath(os.path.join(rdl_dir, "../verif/uvm"))
outdir = os.path.join(verif_dir, 
                      "verification_ip/environment_packages",
                      "fwperiph_dma_4_chan_env_pkg")

cmd = [ 'peakrdl', 'uvm' ]
cmd.append(os.path.join(rdl_dir, "fwperiph_dma.rdl"))
cmd.extend(['-o', os.path.join(outdir, "fwperiph_dma_ral.sv")])

res = subprocess.run(cmd)

if res.returncode != 0:
    raise Exception("Failed")

