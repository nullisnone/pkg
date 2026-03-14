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


# 1. 全局多核配置（Vivado顶层配置）
puts "设置Vivado全局并行核心数为: $cpu_cores"
set_param general.maxThreads $cpu_cores

# 2. 打开工程
puts "打开工程: $project_dir/$project_name.xpr"
if {[file exists "$project_dir/$project_name.xpr"]} {
    open_project "$project_dir/$project_name.xpr"
} else {
    puts "工程文件不存在: $project_dir/$project_name.xpr"
}

# 2.5 运行综合流程
puts "开始运行synth_1综合流程（${cpu_cores}核并行）"
reset_run synth_1
launch_runs synth_1 -jobs $cpu_cores
wait_on_run synth_1

# 检查综合是否成功
set synth_status [get_property STATUS [get_runs synth_1]]
if {$synth_status != "synth_design Complete!"} {
    puts "synth_1综合流程失败，状态: $synth_status"
    exit 1
}
puts "synth_1综合流程成功完成"

# 3. 为impl_1配置16核并行（关键步骤）
puts "为impl_1配置16核并行参数"
current_run -implementation [get_runs impl_1]

# 4. 运行impl_1实现流程（8核并行）
puts "开始运行impl_1实现流程（8核并行）"
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs $cpu_cores
wait_on_run impl_1

# 检查实现是否成功
set run_status [get_property STATUS [get_runs impl_1]]
if {$run_status != "write_bitstream Complete!"} {
    puts "impl_1实现流程失败，状态: $run_status"
}

# 6. 检查比特流文件是否生成成功
if {[file exists "$project_dir/$project_name.runs/impl_1/$project_name.bit"]} {
    puts "比特流生成成功！文件路径: $project_dir/$project_name.runs/impl_1/$project_name.bit"
} else {
    puts "比特流文件生成失败！"
}

puts "生成MCS(.mcs)"
write_cfgmem  -force -format mcs -size 64 -interface SPIx8 -loadbit "up 0x00000000 $project_dir/$project_name.runs/impl_1/$project_name.bit" -file "$project_dir/$project_name.mcs"
puts "生成BIN(.bin)"
write_cfgmem  -force -format bin -size 64 -interface SPIx8 -loadbit "up 0x00000000 $project_dir/$project_name.runs/impl_1/$project_name.bit" -file "$project_dir/$project_name.bin"

# 7. 关闭工程
close_project
puts "========================================"
puts "8核并行比特流生成流程完成 - [clock format [clock seconds]]"
puts "========================================"

exit 0
