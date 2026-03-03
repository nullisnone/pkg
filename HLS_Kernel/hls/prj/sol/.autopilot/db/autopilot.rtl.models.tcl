set SynModuleInfo {
  {SRCNAME Block_entry5_proc3 MODELNAME Block_entry5_proc3 RTLNAME yusur_hash_allocation_Block_entry5_proc3
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_regslice_both RTLNAME yusur_hash_allocation_regslice_both BINDTYPE interface TYPE interface_regslice INSTNAME yusur_hash_allocation_regslice_both_U}
    }
  }
  {SRCNAME Loop_VITIS_LOOP_105_1_proc4 MODELNAME Loop_VITIS_LOOP_105_1_proc4 RTLNAME yusur_hash_allocation_Loop_VITIS_LOOP_105_1_proc4
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_flow_control_loop_pipe RTLNAME yusur_hash_allocation_flow_control_loop_pipe BINDTYPE interface TYPE internal_upc_flow_control INSTNAME yusur_hash_allocation_flow_control_loop_pipe_U}
    }
  }
  {SRCNAME Loop_LOOP_FORWARD_proc MODELNAME Loop_LOOP_FORWARD_proc RTLNAME yusur_hash_allocation_Loop_LOOP_FORWARD_proc}
  {SRCNAME yusur_hash_allocation MODELNAME yusur_hash_allocation RTLNAME yusur_hash_allocation IS_TOP 1
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_batch_data_V_RAM_AUTO_1R1W_memcore RTLNAME yusur_hash_allocation_batch_data_V_RAM_AUTO_1R1W_memcore BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_batch_data_V_RAM_AUTO_1R1W RTLNAME yusur_hash_allocation_batch_data_V_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_keep_data_V_RAM_AUTO_1R1W_memcore RTLNAME yusur_hash_allocation_keep_data_V_RAM_AUTO_1R1W_memcore BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_keep_data_V_RAM_AUTO_1R1W RTLNAME yusur_hash_allocation_keep_data_V_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_last_data_V_RAM_AUTO_1R1W_memcore RTLNAME yusur_hash_allocation_last_data_V_RAM_AUTO_1R1W_memcore BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_last_data_V_RAM_AUTO_1R1W RTLNAME yusur_hash_allocation_last_data_V_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_fifo_w32_d2_S RTLNAME yusur_hash_allocation_fifo_w32_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME pkt_len_1_loc_channel_U}
    }
  }
}
