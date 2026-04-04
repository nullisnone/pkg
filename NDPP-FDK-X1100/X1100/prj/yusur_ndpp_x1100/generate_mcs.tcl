#!/usr/bin/tclsh
#----------------------------------------------------------------------
# 生成比特流的自动化TCL脚本（8核并行版）
# 适配Vivado 2022.2，基于project_name.xpr工程配置
# 强制impl_1阶段使用16 个CPU核心
#----------------------------------------------------------------------

# 配置参数（根据你的实际路径修改）
set project_name "yusur_ndpp_x1100"
set project_dir "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100/X1100/prj/yusur_ndpp_x1100"
set cpu_cores 16  ;# 指定使用16个CPU核心

puts "生成MCS(.mcs)"
write_cfgmem  -force -format mcs -size 64 -interface SPIx8 -loadbit "up 0x00000000 $project_dir/$project_name.runs/impl_1/$project_name.bit" -file "$project_dir/$project_name.mcs"
puts "生成BIN(.bin)"
write_cfgmem  -force -format bin -size 64 -interface SPIx8 -loadbit "up 0x00000000 $project_dir/$project_name.runs/impl_1/$project_name.bit" -file "$project_dir/$project_name.bin"

exit 0
