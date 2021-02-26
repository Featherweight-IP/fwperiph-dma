'''
Created on Feb 23, 2021

@author: mballance
'''
from wishbone_bfms.wb_initiator_bfm import WbInitiatorBfm

class DmaChannelRegs(object):
    
    class CSR(object):
        
        def __init__(self, value=0):
            self.en = (value & 1)
            self.dst_sel = ((value >> 1) & 1)
            self.src_sel = ((value >> 2) & 1)
            self.inc_dst = ((value >> 3) & 1)
            self.inc_src = ((value >> 4) & 1)
            self.mode    = ((value >> 5) & 1)
            self.ars     = ((value >> 6) & 1)
            self.use_ed  = ((value >> 7) & 1)
            self.sz_wb   = ((value >> 8) & 1)
            self.stop    = ((value >> 9) & 1)
            self.busy    = ((value >> 10) & 1)
            self.done    = ((value >> 11) & 1)
            self.err     = ((value >> 12) & 1)
            self.pri     = ((value >> 13) & 7)
            self.rest_en = ((value >> 16) & 1)
            self.ine_err      = ((value >> 17) & 1)
            self.ine_done     = ((value >> 18) & 1)
            self.ine_chk_done = ((value >> 19) & 1)
            self.irq_err      = ((value >> 20) & 1)
            self.irq_done     = ((value >> 21) & 1)
            self.irq_chk_done = ((value >> 22) & 1)
            
        def value(self) -> int:
            return (
                (self.en & 1)
                | ((self.dst_sel & 1) << 1)
                | ((self.src_sel & 1) << 2)
                | ((self.inc_dst & 1) << 3)
                | ((self.inc_src & 1) << 4)
                | ((self.mode & 1) << 5)
                | ((self.ars & 1) << 6)
                | ((self.use_ed & 1) << 7)
                | ((self.sz_wb & 1) << 8)
                | ((self.stop & 1) << 9)
                | ((self.busy & 1) << 10)
                | ((self.done & 1) << 11)
                | ((self.err & 1) << 12)
                | ((self.pri & 7) << 13)
                | ((self.rest_en & 1) << 16)
                | ((self.ine_err & 1) << 17)
                | ((self.ine_done & 1) << 18)
                | ((self.ine_chk_done & 1) << 19)
                | ((self.irq_err & 1) << 20)
                | ((self.irq_done & 1) << 21)
                | ((self.irq_chk_done & 1) << 22)
                )
            
        def __int__(self) -> int:
            return self.value()
        
    class SZ(object):
        
        def __init__(self, value):
            self.tot_sz = (value & 0xFFF)
            self.chk_sz = (value >> 16) & 0xFF
            
        def value(self) -> int:
            return (
                self.chk_sz
                | (self.tot_sz << 16))
            
        def __int__(self) -> int:
            return self.value()
    
    def __init__(self,
                 reg_bfm : WbInitiatorBfm,
                 base_addr):
        self.reg_bfm   = reg_bfm
        self.base_addr = base_addr
        
    async def read_csr(self) -> 'DmaChannelRegs.CSR':
        value = await self.reg_bfm.read(self.base_addr)
        return DmaChannelRegs.CSR(value)

    async def write_csr(self, val : 'DmaChannelRegs.CSR'):
        await self.reg_bfm.write(self.base_addr, val.value(), 0xF)
        
    async def read_sz(self) -> 'DmaChannelRegs.SZ':
        value = await self.reg_bfm.read(self.base_addr+4)
        return DmaChannelRegs.SZ(value)

    async def write_sz(self, val):
        await self.reg_bfm.write(self.base_addr+4, int(val))




    