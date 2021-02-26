set script_dir [file dirname [file normalize [info script]]]

set ::env(CLOCK_PORT) "clock"
set ::env(CLOCK_PERIOD) "25"

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1200 1200"
set ::env(DESIGN_IS_CORE) 0

#set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

#set ::env(PL_BASIC_PLACEMENT) 1
#set ::env(PL_TARGET_DENSITY) 0.01
#set ::env(PL_TARGET_DENSITY) 0.50

#set ::env(DIODE_INSERTION_STRATEGY) 1
#set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 4

#set ::env(ROUTING_CORES) 10
#set ::env(GLB_RT_MAXLAYER) 4
set ::env(DESIGN_IS_CORE) 0

set ::env(VDD_NETS) [list {vccd1} {vccd2} {vdda1} {vdda2}]
set ::env(GND_NETS) [list {vssd1} {vssd2} {vssa1} {vssa2}]

#set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

#set ::env(PL_BASIC_PLACEMENT) 1
set ::env(PL_TARGET_DENSITY) 0.32

# If you're going to use multiple power domains, then keep this disabled.
set ::env(RUN_CVC) 0

