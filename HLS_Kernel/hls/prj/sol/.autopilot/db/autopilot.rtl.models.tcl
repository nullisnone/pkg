set SynModuleInfo {
  {SRCNAME yusur_hash_allocation_Pipeline_LOOP_READ_PACKET MODELNAME yusur_hash_allocation_Pipeline_LOOP_READ_PACKET RTLNAME yusur_hash_allocation_yusur_hash_allocation_Pipeline_LOOP_READ_PACKET
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_flow_control_loop_pipe_sequential_init RTLNAME yusur_hash_allocation_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME yusur_hash_allocation_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME yusur_hash_allocation_Pipeline_LOOP_CALC_VITIS_LOOP_162_2 MODELNAME yusur_hash_allocation_Pipeline_LOOP_CALC_VITIS_LOOP_162_2 RTLNAME yusur_hash_allocation_yusur_hash_allocation_Pipeline_LOOP_CALC_VITIS_LOOP_162_2
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_mul_8ns_8ns_16_1_1 RTLNAME yusur_hash_allocation_mul_8ns_8ns_16_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_mac_muladd_8ns_8ns_16ns_16_4_1 RTLNAME yusur_hash_allocation_mac_muladd_8ns_8ns_16ns_16_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME yusur_hash_allocation_Pipeline_LOOP_OUTPUT_BEATS MODELNAME yusur_hash_allocation_Pipeline_LOOP_OUTPUT_BEATS RTLNAME yusur_hash_allocation_yusur_hash_allocation_Pipeline_LOOP_OUTPUT_BEATS
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_mux_325_16_1_1 RTLNAME yusur_hash_allocation_mux_325_16_1_1 BINDTYPE op TYPE mux IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME yusur_hash_allocation MODELNAME yusur_hash_allocation RTLNAME yusur_hash_allocation IS_TOP 1
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_yusur_hash_allocation_stream_stream_stream_stream_axis_0_A_MATRIX_9_RAM_AUTO_bkb RTLNAME yusur_hash_allocation_yusur_hash_allocation_stream_stream_stream_stream_axis_0_A_MATRIX_9_RAM_AUTO_bkb BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_yusur_hash_allocation_stream_stream_stream_stream_axis_0_C_MATRIX_9_RAM_AUTO_ehP RTLNAME yusur_hash_allocation_yusur_hash_allocation_stream_stream_stream_stream_axis_0_C_MATRIX_9_RAM_AUTO_ehP BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_regslice_both RTLNAME yusur_hash_allocation_regslice_both BINDTYPE interface TYPE interface_regslice INSTNAME yusur_hash_allocation_regslice_both_U}
    }
  }
}
