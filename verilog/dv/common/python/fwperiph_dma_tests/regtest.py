'''
Created on Jan 25, 2021

@author: mballance
'''

import cocotb
import pybfms


@cocotb.test()
async def test(top):
    await pybfms.init()
    
    u_reg_bfm = pybfms.find_bfm(".*u_reg_bfm")
    
    exp = [
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0),
        (0, 0)
        ];
        
    for i,vm in enumerate(exp):
        await u_reg_bfm.write(4*i, 0x5555aaa5, 0xF)
        data = await u_reg_bfm.read(4*i)
        print("Read: " + hex(4*i) + " " + hex(data))
        
        
    print("Hello")
    pass