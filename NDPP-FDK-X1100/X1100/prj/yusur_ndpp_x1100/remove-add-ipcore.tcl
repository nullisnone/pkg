open_project project_1.xpr

update_compile_order -fileset sources_1

update_ip_catalog -delete_ip xilinx.com:hls:yusur_hash_allocation:1.0 -repo_path /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/ip_repo

update_ip_catalog -add_ip /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/ip_repo/yusur_hash_allocation.zip -repo_path /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/ip_repo

upgrade_ip -srcset design_1_yusur_hash_allocation_0_0 -vlnv xilinx.com:hls:yusur_hash_allocation:1.0 [get_ips  design_1_yusur_hash_allocation_0_0] -log ip_upgrade.log

export_ip_user_files -of_objects [get_ips design_1_yusur_hash_allocation_0_0] -no_script -sync -force -quiet

update_compile_order -fileset sources_1

generate_target all [get_files  /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.srcs/sources_1/ip/design_1_yusur_hash_allocation_0_0/design_1_yusur_hash_allocation_0_0.xci]

export_ip_user_files -of_objects [get_files /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.srcs/sources_1/ip/design_1_yusur_hash_allocation_0_0/design_1_yusur_hash_allocation_0_0.xci] -no_script -sync -force -quiet

create_ip_run [get_files -of_objects [get_fileset sources_1] /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.srcs/sources_1/ip/design_1_yusur_hash_allocation_0_0/design_1_yusur_hash_allocation_0_0.xci]

launch_runs design_1_yusur_hash_allocation_0_0_synth_1 -jobs 14

export_simulation -of_objects [get_files /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.srcs/sources_1/ip/design_1_yusur_hash_allocation_0_0/design_1_yusur_hash_allocation_0_0.xci] -directory /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.ip_user_files/sim_scripts -ip_user_files_dir /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.ip_user_files -ipstatic_source_dir /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.ip_user_files/ipstatic -lib_map_path [list {modelsim=/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.cache/compile_simlib/modelsim} {questa=/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.cache/compile_simlib/questa} {xcelium=/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.cache/compile_simlib/xcelium} {vcs=/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.cache/compile_simlib/vcs} {riviera=/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/x1100_prj/prj/project_1/project_1.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
