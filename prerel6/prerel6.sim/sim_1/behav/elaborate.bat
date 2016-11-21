@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto c1d64e4d9c984244944e9a9f0333952c -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot prerel6_behav xil_defaultlib.prerel6 -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
