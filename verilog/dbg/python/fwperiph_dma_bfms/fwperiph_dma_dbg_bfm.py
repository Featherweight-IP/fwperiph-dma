'''
Created on Feb 8, 2021

@author: mballance
'''
import pybfms

@pybfms.bfm(
    hdl={
        pybfms.BfmType.SystemVerilog : pybfms.bfm_hdl_path(__file__, "hdl/fwperiph_dma_dbg_bfm.v"),
        pybfms.BfmType.Verilog : pybfms.bfm_hdl_path(__file__, "hdl/fwperiph_dma_dbg_bfm.v")
        }, 
    has_init=True)
class FwPeriphDmaDbgBfm(object):
    class Channel(object):
        
        def __init__(self):
            self.csr = 0x00000000
            self.sz = 0x00000000
            self.chk_sz = 0x00000000
            self.src = 0x0000000
            self.dst = 0x0000000
            pass
    
    def __init__(self):
        self.n_channels = 0
        self.channels : FwPeriphDmaDbgBfm.Channel = []
        for i in range(32):
            self.channels.append(FwPeriphDmaDbgBfm.Channel())
        pass
    
    @pybfms.export_task(pybfms.uint32_t,pybfms.uint32_t)
    def _reg_write(self, adr, dat):
        
        if adr < 8:
            pass
        else:
            # Channel register
            channel = int((adr - 8) / 8)
            reg = int((adr - 8) % 8)
            
            ch_reg : FwPeriphDmaDbgBfm.Channel = self.channels[channel]
            
            if reg == 0: # CSR
                if (ch_reg.csr & 1) != (dat & 1):
                    # TODO: update state based on enablement
                    if (ch_reg.csr & 1):
                        # blank registers
                        ch_reg.csr = dat
                        self._update_channel(channel, ch_reg)
                ch_reg.csr = dat
            elif reg == 1: # SZ
                ch_reg.sz = (dat & 0xFFF)
                ch_reg.chk_sz = (dat >> 16) & 0x1FF
            elif reg == 2: # SRC
                ch_reg.src = dat
            elif reg == 3: # SRC_MSK
                pass
            elif reg == 4: # DST
                ch_reg.dst = dat
            elif reg == 5: # DST_MSK
                pass
            elif reg == 6: # LL_PTR
                pass
            else: # SW_PTR
                pass
            
            if (ch_reg.csr & 1):
                # Update display
                self._update_channel(channel, ch_reg)
            
                
            print("channel %d reg %d" % (channel,reg))
        pass
    
    def _update_channel(self, channel, ch_regs):
        self._clr_src_s(channel)
        self._clr_dst_s(channel)
        self._clr_sz_s(channel)
        
        if ch_regs.csr & 1:
            # TODO: update content
            self._set_src_s(channel, 
                "0x%08x (%s)" % (
                    ch_regs.src, 
                    "inc" if (ch_regs.csr & 0x08) != 0 else "fix"))
            self._set_dst_s(channel, 
                "0x%08x (%s)" % (
                    ch_regs.dst, 
                    "inc" if (ch_regs.csr & 0x10) != 0 else "fix"))

            self._set_sz_s(channel, 
                "%d (burst %d)" % (
                    ch_regs.sz,
                    ch_regs.chk_sz))
    
    @pybfms.import_task(pybfms.uint8_t)
    def _clr_src_s(self, channel):
        pass
    
    def _set_src_s(self, channel, val):
        for i,c in enumerate(val.encode()):
            self._set_src_c(channel, i, c)
    
    @pybfms.import_task(pybfms.uint8_t,pybfms.uint8_t,pybfms.uint8_t)
    def _set_src_c(self, channel, idx, ch):
        pass
    
    @pybfms.import_task(pybfms.uint8_t)
    def _clr_dst_s(self, channel):
        pass
    
    def _set_dst_s(self, channel, val):
        for i,c in enumerate(val.encode()):
            self._set_dst_c(channel, i, c)
    
    @pybfms.import_task(pybfms.uint8_t,pybfms.uint8_t,pybfms.uint8_t)
    def _set_dst_c(self, channel, idx, ch):
        pass
    
    @pybfms.import_task(pybfms.uint8_t)
    def _clr_sz_s(self, channel):
        pass
    
    def _set_sz_s(self, channel, val):
        for i,c in enumerate(val.encode()):
            self._set_sz_c(channel, i, c)
    
    @pybfms.import_task(pybfms.uint8_t,pybfms.uint8_t,pybfms.uint8_t)
    def _set_sz_c(self, channel, idx, ch):
        pass
    
    @pybfms.export_task(pybfms.uint8_t)
    def _notify_complete(self, channel):
        ch_reg : FwPeriphDmaDbgBfm.Channel = self.channels[channel]
        ch_reg.csr &= 0xFFFFFFFE # Clear EN
        self._update_channel(channel, ch_reg)
    
    @pybfms.export_task(pybfms.uint32_t)
    def _set_parameters(self, n_channels):
        pass
