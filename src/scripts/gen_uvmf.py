#!/usr/bin/env python3 
import os
import subprocess

scripts_dir=os.path.dirname(os.path.abspath(__file__))
src_dir=os.path.dirname(scripts_dir)
fwperiph_dma_dir=os.path.dirname(src_dir)

cmd = ['uvmf', '-m', os.path.join(src_dir, 'verif/uvm')]

cmd.append(os.path.join(fwperiph_dma_dir, 'src/verif/uvm/yaml',
                        'fwperiph_dma_4_chan_env.uvmf'))
cmd.append(os.path.join(fwperiph_dma_dir, 'src/verif/uvm/yaml',
                        'fwperiph_dma_4_chan_tb.uvmf'))
cmd.append(os.path.join(fwperiph_dma_dir, 'packages/fwvip-wb/src/vip/yaml',
                        'fwvip_wb.uvmf'))

cmd.extend(['-g', 'fwperiph_dma_4_chan'])
cmd.extend(['-g', 'fwperiph_dma_4_chan_tb'])

res = subprocess.run(cmd)

if res.returncode != 0:
    raise Exception("Generation failed")
