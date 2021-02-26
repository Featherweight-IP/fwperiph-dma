'''
Created on Feb 9, 2021

@author: mballance
'''
import cocotb
import pybfms


@cocotb.test()
async def entry(dut):
    
    await pybfms.init()
   

    pass
