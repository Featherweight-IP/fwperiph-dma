#!/usr/bin/env python3
import os
import subprocess

rdl_dir = os.path.dirname(os.path.abspath(__file__))
src_dir = os.path.dirname(rdl_dir)
outdir = os.path.join(src_dir, "pss")

cmd = [ 'peakrdl', 'pss' ]
cmd.append(os.path.join(rdl_dir, "fwperiph_dma.rdl"))
cmd.extend(['-o', os.path.join(outdir, "fwperiph_dma_ral.pss")])

res = subprocess.run(cmd)

if res.returncode != 0:
    raise Exception("Failed")

