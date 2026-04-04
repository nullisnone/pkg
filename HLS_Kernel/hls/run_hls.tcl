source settings.tcl

set PROJ "prj"
set SOLN "sol"

if {![info exists CLKP]} {
  set CLKP 3.5
}

set CASEDIR [pwd]/../
set KERNELDIR [pwd]/../kernel 
set COMMONDIR [pwd]/../common 
set EXPORTDIR [pwd]/../ip_repo 

open_project -reset $PROJ
 
# add src file 
#add_files "${KERNELDIR}/yusur_udp_filter.cpp" -cflags "-I${KERNELDIR}/kernel"
add_files "${KERNELDIR}/yusur_hash_allocation.cpp" -cflags "-I${KERNELDIR}/kernel"

# add Csim file 
# add_files -tb "${CASEDIR}/host/main.cpp" -cflags "-I${CASEDIR}/host -I${KERNELDIR} -DHLS_TEST" -cflags "-std=c++17"
add_files -tb "${CASEDIR}/host/main.cpp" -cflags "-I${CASEDIR}/host -I${KERNELDIR} -std=c++17 -DHLS_TEST"  


# Select kernel 
#set ip_name yusur_udp_filter
set ip_name yusur_hash_allocation

set_top $ip_name

open_solution -reset $SOLN 

set_part $XPART
create_clock -period $CLKP

if {$CSIM == 1} {
  csim_design
}

if {$CSYNTH == 1} {
  csynth_design
}

if {$COSIM == 1} {
  # cosim_design
  cosim_design -wave_debug -trace_level all
}

set output_file_path "${EXPORTDIR}/${ip_name}.zip" 
if {$VSYNTH == 1} {
  export_design -flow syn -rtl verilog -format ip_catalog -output $output_file_path
}

exit
