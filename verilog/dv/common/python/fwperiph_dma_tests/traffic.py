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
        self.inc_src = vsc.rand_bit_t(i=1)
        self.inc_dst = vsc.rand_bit_t(i=1)
        self.src_addr = 0
        self.dst_addr = 0
        
    @vsc.constraint
    def sz_c(self):
        self.chksz.inside(vsc.rangelist(vsc.rng(1, 64)))
        self.totsz.inside(vsc.rangelist(vsc.rng(16, 4095)))
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
        self.irq_active = False
        pass
    
    async def irq_handler(self):
        while True:
            await self.irq_ev.wait()
            
            print("-- Received IRQ")

            # The handler keeps processing channels 
            # for completion as long as the irq is active
            while self.irq_active:
                for i in range(self.n_channels):
                    if self.active_channels[i]:
                        csr = await self.dma_regs.channel(i).read_csr()
                    
                        if csr.irq_done:
                            self.done_ev[i].set()

                # 5 clock cycles @ 20ns                            
                await cocotb.triggers.Timer(100, "ns")
            
            
            # TODO: read registers and dispatch
            
            self.irq_ev.clear()
    
    def irq_cb(self, val):
        if (val):
            self.irq_active = True
            self.irq_ev.set()
        else:
            self.irq_active = False
    
    async def init_dma(self):
        # Initialize interrupts
        await self.dma_regs.write_int_msk_a(0xFFFFFFFF)
        await self.dma_regs.write_int_msk_b(0x00000000)
        
        # Initialize channels
        for i in range(self.n_channels):
            ch = self.dma_regs.channel(i)
            
            csr = await ch.read_csr()
            csr.en = 0
            await ch.write_csr(csr)
            
    async def run_xfer(self):
        channel = vsc.rand_uint32_t()
        xfer_spec = XferSpec()

        # Randomly select a channel not currently in use        
        with vsc.randomize_with(channel):
            channel < self.n_channels
            with vsc.foreach(self.active_channels, idx=True) as i:
                with vsc.implies(i == channel):
                    self.active_channels[i] == False
        
        print("channel: " + str(channel))
        self.active_xfers += 1
        self.active_channels[channel] = True

        xfer_spec.randomize()        
        # TODO: program channel
        ch = self.dma_regs.channel(int(channel))
        sz = await ch.read_sz()
        sz.chk_sz = xfer_spec.chksz
        sz.tot_sz = xfer_spec.totsz
        await ch.write_sz(sz)
        csr = await ch.read_csr()
        csr.ine_done = 1
        csr.inc_src = xfer_spec.inc_src
        csr.inc_dst = xfer_spec.inc_dst
        
        print("INC_SRC: " + str(csr.inc_src) + " INC_DST: " + str(csr.inc_dst))
        csr.en = 1
        await ch.write_csr(csr)

        await ch.write_src_addr(0x00000000 | int(channel) << 16)
        await ch.write_dst_addr(0x80000000 | int(channel) << 16)
        
        # TODO: start xfer

        # Wait for completion
        await self.done_ev[int(channel)].wait()
        self.done_ev[int(channel)].clear()
        
        
        # TODO: program and carry out transfer
#        await cocotb.triggers.Timer(1, "us")
            
        self.active_xfers -= 1
        print("Channel " + str(channel) + " done " + str(self.active_xfers))
        self.active_channels[channel] = False
        self.n_complete += 1
        pass
    
    async def run(self):
        tasks = []

        cocotb.fork(self.irq_handler())
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
                desired_active = vsc.rand_uint8_t() 
                
                with vsc.randomize_with(desired_active):
                    desired_active.inside(vsc.rangelist(vsc.rng(0,self.n_channels-2)))

                print("--> waiting for transfers to complete (" + str(desired_active) + ")")
                while self.active_xfers > int(desired_active):
                    print("active: " + str(self.active_xfers) + " desired: " + str(desired_active))
                    print("--> Wait for first")
                    await cocotb.triggers.First(*tasks)
                    print("<-- Wait for first")
                    
                    # Now, find completed tasks
                    while len(tasks) > 0:
                        idx = -1;
                        for i,t in enumerate(tasks):
                            if t._finished:
                                idx = i
                                break
                            
                        if idx == -1:
                            print("No more to remove " + str(idx))
                            break
                        else:
                            print("Remove " + str(idx))
                            tasks.pop(idx)
                print("<-- waiting for transfers to complete")
        

        # Wait for any pending transfers to complete
        # First, clean out already-completed transfers        
        while len(tasks) > 0:
            idx = -1;
            for i,t in enumerate(tasks):
                if t._finished:
                    idx = i
                    break
                           
            if idx == -1:
                print("No more to remove " + str(idx))
                break
            else:
                print("Remove " + str(idx))
                tasks.pop(idx)
                
        if len(tasks) > 0:
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
    
    
    
