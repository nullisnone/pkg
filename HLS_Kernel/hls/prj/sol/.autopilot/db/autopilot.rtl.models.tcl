set SynModuleInfo {
  {SRCNAME Block_entry688_proc3 MODELNAME Block_entry688_proc3 RTLNAME yusur_hash_allocation_Block_entry688_proc3
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_regslice_both RTLNAME yusur_hash_allocation_regslice_both BINDTYPE interface TYPE interface_regslice INSTNAME yusur_hash_allocation_regslice_both_U}
    }
  }
  {SRCNAME Loop_LOOP_READ_AND_DRAIN_proc4 MODELNAME Loop_LOOP_READ_AND_DRAIN_proc4 RTLNAME yusur_hash_allocation_Loop_LOOP_READ_AND_DRAIN_proc4
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_flow_control_loop_pipe RTLNAME yusur_hash_allocation_flow_control_loop_pipe BINDTYPE interface TYPE internal_upc_flow_control INSTNAME yusur_hash_allocation_flow_control_loop_pipe_U}
    }
  }
  {SRCNAME Block_while.end_proc MODELNAME Block_while_end_proc RTLNAME yusur_hash_allocation_Block_while_end_proc
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_mul_8ns_8ns_16_1_1 RTLNAME yusur_hash_allocation_mul_8ns_8ns_16_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_mac_muladd_8ns_8ns_16ns_16_4_1 RTLNAME yusur_hash_allocation_mac_muladd_8ns_8ns_16ns_16_4_1 BINDTYPE op TYPE all IMPL dsp48 LATENCY 3 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME Loop_LOOP_OUTPUT_ALL_proc MODELNAME Loop_LOOP_OUTPUT_ALL_proc RTLNAME yusur_hash_allocation_Loop_LOOP_OUTPUT_ALL_proc
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_mux_21_16_1_1 RTLNAME yusur_hash_allocation_mux_21_16_1_1 BINDTYPE op TYPE mux IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME yusur_hash_allocation_mux_83_16_1_1 RTLNAME yusur_hash_allocation_mux_83_16_1_1 BINDTYPE op TYPE mux IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME yusur_hash_allocation MODELNAME yusur_hash_allocation RTLNAME yusur_hash_allocation IS_TOP 1
    SUBMODULES {
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_23_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_22_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_21_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_20_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_19_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_18_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_17_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_16_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_15_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_14_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_13_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_12_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_11_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_10_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_9_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_8_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_7_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_6_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_5_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_4_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_3_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_2_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_1_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME A_MATRIX_load_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc690_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc691_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc692_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc693_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc694_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc695_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc696_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc697_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc698_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc699_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc700_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc701_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc702_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc703_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc704_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc705_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc706_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc707_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc708_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc709_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc710_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc711_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc712_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc713_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc714_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc715_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc716_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc717_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc718_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc719_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc720_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc721_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc722_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc723_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc724_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc725_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc726_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc727_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc728_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc729_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc730_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc731_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc732_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc733_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc734_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc735_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc736_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc737_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc738_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc739_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc740_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc741_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc742_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc743_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc744_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc745_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc746_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc747_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc748_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc749_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc750_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc751_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc752_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc753_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc754_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc755_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc756_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc757_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc758_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc759_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc760_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc761_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc762_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc763_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc764_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc765_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc766_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc767_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc768_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc769_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc770_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc771_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc772_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc773_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc774_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc775_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc776_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc777_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc778_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc779_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc780_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc781_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc782_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc783_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc784_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc785_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc786_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc787_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc788_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc789_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc790_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc791_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME p_loc792_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME HEADER_INFO_7_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME HEADER_INFO_6_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME HEADER_INFO_5_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME HEADER_INFO_4_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME HEADER_INFO_3_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME HEADER_INFO_2_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME HEADER_INFO_1_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w8_d2_S RTLNAME yusur_hash_allocation_fifo_w8_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME HEADER_INFO_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_518_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_525_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_532_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_539_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_546_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_553_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_560_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_567_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_623_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_616_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_609_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_602_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_595_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_588_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_581_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_574_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_679_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_672_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_665_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_658_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_651_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_644_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_637_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_630_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_735_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_728_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_721_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_714_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_707_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_700_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_693_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_686_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_791_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_784_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_777_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_770_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_763_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_756_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_749_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_742_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_847_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_840_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_833_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_826_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_819_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_812_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_805_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_798_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_903_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_896_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_889_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_882_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_875_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_868_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_861_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_854_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_959_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_952_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_945_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_938_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_931_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_924_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_917_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w16_d2_S RTLNAME yusur_hash_allocation_fifo_w16_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME sum_910_loc_channel_U}
      {MODELNAME yusur_hash_allocation_fifo_w64_d2_S RTLNAME yusur_hash_allocation_fifo_w64_d2_S BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME or_i15_7_loc_channel_U}
    }
  }
}
