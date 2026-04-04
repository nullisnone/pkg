set ip_repo_dir "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100/ip_repo/"
set ip_instance "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100/X1100/ip/design_1_yusur_hash_allocation_0_0/design_1_yusur_hash_allocation_0_0.xci"
set project_dir "/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100/X1100/prj/yusur_ndpp_x1100"
set project_name "yusur_ndpp_x1100"

open_project yusur_ndpp_x1100.xpr

update_compile_order -fileset sources_1

update_ip_catalog -delete_ip xilinx.com:hls:yusur_hash_allocation:1.0 -repo_path $ip_repo_dir

update_ip_catalog -add_ip $ip_repo_dir/yusur_hash_allocation.zip -repo_path $ip_repo_dir

upgrade_ip -srcset design_1_yusur_hash_allocation_0_0 -vlnv xilinx.com:hls:yusur_hash_allocation:1.0 [get_ips  design_1_yusur_hash_allocation_0_0] -log ip_upgrade.log

export_ip_user_files -of_objects [get_ips design_1_yusur_hash_allocation_0_0] -no_script -sync -force -quiet

update_compile_order -fileset sources_1

generate_target all [get_files $ip_instance]

export_ip_user_files -of_objects [get_files $ip_instance] -no_script -sync -force -quiet

create_ip_run [get_files -of_objects [get_fileset sources_1] $ip_instance]

launch_runs design_1_yusur_hash_allocation_0_0_synth_1 -jobs 14

export_simulation -of_objects [get_files $ip_instance] -directory $project_dir/$project_name.ip_user_files/sim_scripts -ip_user_files_dir $project_dir/$project_name.ip_user_files -ipstatic_source_dir $project_dir/$project_name.ip_user_files/ipstatic -lib_map_path [list {modelsim=$project_dir/$project_name.cache/compile_simlib/modelsim} {questa=$project_dir/$project_name.cache/compile_simlib/questa} {xcelium=$project_dir/$project_name.cache/compile_simlib/xcelium} {vcs=$project_dir/$project_name.cache/compile_simlib/vcs} {riviera=$project_dir/$project_name.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
