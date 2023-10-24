 

onerror resume
wave tags F0
wave update off

wave spacer -backgroundcolor Salmon { reg_initiator }
wave add uvm_test_top.environment.reg_initiator.reg_initiator_monitor.txn_stream -radix string -tag F0
wave group reg_initiator_bus
wave add -group reg_initiator_bus hdl_top.reg_initiator_bus.* -radix hexadecimal -tag F0
wave group reg_initiator_bus -collapse
wave insertion [expr [wave index insertpoint] +1]



wave update on
WaveSetStreamView

