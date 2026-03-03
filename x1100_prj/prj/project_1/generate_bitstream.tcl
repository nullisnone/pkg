#!/usr/bin/tclsh
#----------------------------------------------------------------------
# 生成比特流的自动化TCL脚本（8核并行版）
# 适配Vivado 2022.2，基于project_1.xpr工程配置
# 强制impl_1阶段使用8个CPU核心
#----------------------------------------------------------------------

# 配置参数（根据你的实际路径修改）
set project_name "project_1"
set output_name "yusur_ndpp_x1100"
set project_dir "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1"
set cpu_cores 8  ;# 指定使用8个CPU核心

# 设置日志文件
set log_file "./bitstream_gen_8core.log"
set chan [open $log_file w]
puts $chan "========================================"
puts $chan "开始生成比特流（8核并行）- [clock format [clock seconds]]"
puts $chan "指定CPU核心数: $cpu_cores"
puts $chan "========================================"
close $chan

# 定义日志输出函数
proc log_info {msg} {
    global log_file
    set chan [open $log_file a]
    puts $chan "[clock format [clock seconds]] - INFO: $msg"
    close $chan
    puts $msg
    puts "INFO: $msg"
}

proc log_error {msg} {
    global log_file
    set chan [open $log_file a]
    puts $chan "[clock format [clock seconds]] - ERROR: $msg"
    close $chan
    puts "ERROR: $msg"
}

# 1. 全局多核配置（Vivado顶层配置）
log_info "设置Vivado全局并行核心数为: $cpu_cores"
set_param general.maxThreads $cpu_cores

# 2. 打开工程
log_info "打开工程: $project_dir/$project_name.xpr"
if {[file exists "$project_dir/$project_name.xpr"]} {
    open_project "$project_dir/$project_name.xpr"
} else {
    log_error "工程文件不存在: $project_dir/$project_name.xpr"
}

# 2.5 运行综合流程
log_info "开始运行synth_1综合流程（${cpu_cores}核并行）"
reset_run synth_1
launch_runs synth_1 -jobs $cpu_cores
wait_on_run synth_1

# 检查综合是否成功
set synth_status [get_property STATUS [get_runs synth_1]]
if {$synth_status != "synth_design Complete!"} {
    log_error "synth_1综合流程失败，状态: $synth_status"
    exit 1
}
log_info "synth_1综合流程成功完成"

# 3. 为impl_1配置8核并行（关键步骤）
log_info "为impl_1配置8核并行参数"
current_run -implementation [get_runs impl_1]

# 4. 运行impl_1实现流程（8核并行）
log_info "开始运行impl_1实现流程（8核并行）"
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs $cpu_cores
wait_on_run impl_1

# 检查实现是否成功
set run_status [get_property STATUS [get_runs impl_1]]
if {$run_status != "write_bitstream Complete!"} {
    log_error "impl_1实现流程失败，状态: $run_status"
}

# 6. 检查比特流文件是否生成成功
if {[file exists "$project_dir/project_1.runs/impl_1/$output_name.bit"]} {
    log_info "比特流生成成功！文件路径: $project_dir/project_1.runs/impl_1/$output_name.bit"
} else {
    log_error "比特流文件生成失败！"
}

log_info "生成MCS(.mcs)"
write_cfgmem  -force -format mcs -size 64 -interface SPIx8 -loadbit "up 0x00000000 $project_dir/project_1.runs/impl_1/$output_name.bit" -file "$project_dir/$output_name.mcs"
log_info "生成BIN(.bin)"
write_cfgmem  -force -format bin -size 64 -interface SPIx8 -loadbit "up 0x00000000 $project_dir/project_1.runs/impl_1/$output_name.bit" -file "$project_dir/$output_name.bin"

# 7. 关闭工程
close_project
log_info "========================================"
log_info "8核并行比特流生成流程完成 - [clock format [clock seconds]]"
log_info "========================================"

exit 0
