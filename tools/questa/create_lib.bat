if  exist ..\..\work\compilation\unisim goto xilinxcorelib
cd ..\..\work\compilation
vlib unisim
vmap unisim unisim
vcom -work unisim %XILINX%\vhdl\src\unisims\unisim_VPKG.vhd
vcom -work unisim %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
cd ..\..\tools\questa

:xilinxcorelib
if  exist ..\..\work\compilation\xilinxcorelib goto do_nothing
cd ..\..\work\compilation
vlib xilinxcorelib
vmap xilinxcorelib xilinxcorelib
vcom -work xilinxcorelib %XILINX%\vhdl\src\xilinxcorelib\fifo_generator_v9_1.vhd
vcom -work xilinxcorelib %XILINX%\vhdl\src\XilinxcoreLib\fifo_generator_v9_1_comp.vhd
cd ..\..\tools\questa

:do_nothing
pause