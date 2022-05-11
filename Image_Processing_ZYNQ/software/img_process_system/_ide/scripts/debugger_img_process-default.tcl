# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Users\Stanc\Documents\Image_Processing_ZYNQ\software\img_process_system\_ide\scripts\debugger_img_process-default.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Users\Stanc\Documents\Image_Processing_ZYNQ\software\img_process_system\_ide\scripts\debugger_img_process-default.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zybo Z7 210351B3FE7AA" && level==0 && jtag_device_ctx=="jsn-Zybo Z7-210351B3FE7AA-13722093-0"}
fpga -file C:/Users/Stanc/Documents/Image_Processing_ZYNQ/software/img_process/_ide/bitstream/design_1_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Users/Stanc/Documents/Image_Processing_ZYNQ/software/design_1_wrapper/export/design_1_wrapper/hw/design_1_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Users/Stanc/Documents/Image_Processing_ZYNQ/software/img_process/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Users/Stanc/Documents/Image_Processing_ZYNQ/software/img_process/Debug/img_process.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
