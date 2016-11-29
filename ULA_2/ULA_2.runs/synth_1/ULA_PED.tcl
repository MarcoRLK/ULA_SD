# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/Marco/Google Drive/Engenharia/SD1/PED/ULA_2/ULA_2.cache/wt} [current_project]
set_property parent.project_path {C:/Users/Marco/Google Drive/Engenharia/SD1/PED/ULA_2/ULA_2.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_vhdl -library xil_defaultlib {{C:/Users/Marco/Google Drive/Engenharia/SD1/PED/ULA_2/ULA_2.srcs/sources_1/new/ULA_PED.vhd}}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/Marco/Google Drive/Engenharia/SD1/PED/ULA_2/Basys3_Master.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/Marco/Google Drive/Engenharia/SD1/PED/ULA_2/Basys3_Master.xdc}}]


synth_design -top ULA_PED -part xc7a35tcpg236-1


write_checkpoint -force -noxdef ULA_PED.dcp

catch { report_utilization -file ULA_PED_utilization_synth.rpt -pb ULA_PED_utilization_synth.pb }
