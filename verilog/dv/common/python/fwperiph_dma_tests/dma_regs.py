'''
Created on Feb 23, 2021

@author: mballance
'''
from fwperiph_dma_tests.dma_channel_regs import DmaChannelRegs

class DmaRegs(object):
    
    class CSR(object):

        def __init__(self, value):
            pass
        
        def value(self) -> int:
            pass
    
    def __init__(self, 
                 reg_bfm,
                 base_addr):
        self.reg_bfm = reg_bfm
        self.base_addr = base_addr
        
    async def read_csr(self):
        return await self.reg_bfm.read(self.base_addr)
    
    async def write_csr(self, value):
        await self.reg_bfm.write(self.base_addr, value, 0xF)
        
    async def read_int_msk_a(self):
        return await self.reg_bfm.read(self.base_addr+4)
    
    async def write_int_msk_a(self, value):
        await self.reg_bfm.write(self.base_addr+4, value)
        
    async def read_int_msk_b(self):
        return await self.reg_bfm.read(self.base_addr+8)
    
    async def write_int_msk_b(self, value):
        await self.reg_bfm.write(self.base_addr+8, value)
        
    async def read_int_src_a(self):
        return await self.reg_bfm.read(self.base_addr+0xC)
    
    async def write_int_src_a(self, value):
        await self.reg_bfm.write(self.base_addr+0xC, value)
        
    async def read_int_src_b(self):
        return await self.reg_bfm.read(self.base_addr+0x10)
    
    async def write_int_src_b(self, value):
        await self.reg_bfm.write(self.base_addr+0x10, value)
        
    def channel(self, num) -> DmaChannelRegs:
        return DmaChannelRegs(
            self.reg_bfm,
            self.base_addr + 0x20 + (4*8*num))
            