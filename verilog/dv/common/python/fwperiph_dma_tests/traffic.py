'''
Created on Feb 23, 2021

@author: mballance
'''

import cocotb
import pybfms
import vsc
from wishbone_bfms.wb_initiator_bfm import WbInitiatorBfm
from event_bfms.event_bfm import EventBfm
from fwperiph_dma_tests.dma_regs import DmaRegs

@vsc.randobj
class XferSpec(object):
    
    def __init__(self):
        self.chksz = vsc.rand_uint8_t()
        self.totsz = vsc.rand_uint16_t()
        self.inc_src = vsc.bit_t(i=1)
        self.inc_dst = vsc.bit_t(i=1)
        self.src_addr = 0
        self.dst_addr = 0
        
    @vsc.constraint
    def sz_c(self):
        self.chksz.inside(vsc.rng(1, 64))
        self.totsz.inside(vsc.rng(16, 4095))
        self.chksz <= self.totsz

class TrafficTest(object):
    
    def __init__(self, reg_bfm, irq_bfm):
        self.reg_bfm = reg_bfm
        self.irq_bfm = irq_bfm
        self.n_channels = 4
        self.dma_regs = DmaRegs(self.reg_bfm, 0x00000000)
        self.total_xfers = 100
        self.active_channels = vsc.list_t(vsc.bool_t(), self.n_channels)
        
        self.done_ev = []
        for i in range(self.n_channels):
            self.done_ev.append(cocotb.triggers.Event())
            
        self.irq_ev = cocotb.triggers.Event()
            
        self.active_xfers = 0
        self.n_complete = 0
        pass
    
    async def irq_handler(self):
        while True:
            await self.irq_ev.wait()
            
            # TODO: read registers and dispatch
            
            self.irq_ev.clear()
    
    def irq_cb(self, val):
        self.irq_ev.set()
    
    async def init_dma(self):
        # Initialize interrupts
        self.dma_regs.write_int_msk_a(0xFFFFFFFF)
        self.dma_regs.write_int_msk_b(0x00000000)
        
        # Initialize channels
        for i in range(self.n_channels):
            ch = self.dma_regs.channel(i)
            
            csr = await ch.read_csr()
            csr.en = 0
            await ch.write_csr(csr)
            
    async def run_xfer(self):
        channel = vsc.rand_uint32_t()

        # Randomly select a channel not currently in use        
        with vsc.randomize_with(channel):
            channel < self.n_channels
            with vsc.foreach(self.active_channels, idx=True) as i:
                with vsc.implies(i == channel):
                    self.active_channels[i] == False
        
        print("channel: " + str(channel))
        self.active_xfers += 1
        self.active_channels[channel] = True
        
        # TODO: program channel
        
        # TODO: start xfer
        
        await self.done_ev[int(channel)].wait()
        self.done_ev[int(channel)].clear()
        
        # TODO: program and carry out transfer
        await cocotb.triggers.Timer(1, "us")
            
        self.active_xfers -= 1
        self.active_channels[channel] = False
        pass
    
    async def run(self):
        tasks = []

        self.irq_bfm.add_callback(self.irq_cb)
        await self.init_dma()

        while self.n_complete < self.total_xfers:
            t = cocotb.fork(self.run_xfer())
            tasks.append(t)
            
            # TODO: Delay a random amount before 
            # starting the next transfer

            # If all channels are occupied, then clean 
            # up at least enough tasks to allow us to 
            # proceed
            if self.active_xfers == self.n_channels:
                desired_active = 0 # TODO: should randomize

                print("--> waiting for transfers to complete")
                while self.active_xfers > desired_active:
                    t = tasks.pop(0)
                    await cocotb.triggers.Join(t)
                print("<-- waiting for transfers to complete")
        
        # TODO: wait for any pending transfers to complete
        
        await cocotb.triggers.Combine(*tasks)
        

@cocotb.test()
async def test(top):
    
    await pybfms.init()
    
    reg_bfm = pybfms.find_bfm(".*u_reg_bfm") #, WbInitiatorBfm)
    irq_bfm = pybfms.find_bfm(".*u_irq") #, EventBfm)
    
    
    tt = TrafficTest(reg_bfm, irq_bfm)
    
    await tt.run()
    
    # Initialize interrupt configuration
    
    # Initialize channel registers
    
    
    
