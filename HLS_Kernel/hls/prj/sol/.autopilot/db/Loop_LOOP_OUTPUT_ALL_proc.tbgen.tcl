set moduleName Loop_LOOP_OUTPUT_ALL_proc
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {Loop_LOOP_OUTPUT_ALL_proc}
set C_modelType { void 0 }
set C_modelArgList {
	{ p_read int 8 regular  }
	{ p_read1 int 8 regular  }
	{ p_read2 int 8 regular  }
	{ p_read3 int 8 regular  }
	{ p_read4 int 8 regular  }
	{ p_read5 int 8 regular  }
	{ p_read6 int 8 regular  }
	{ p_read7 int 8 regular  }
	{ o_axiu_user0_data_V_data_V int 64 regular {axi_s 1 volatile  { o_axiu_user0_data Data } }  }
	{ o_axiu_user0_data_V_keep_V int 8 regular {axi_s 1 volatile  { o_axiu_user0_data Keep } }  }
	{ o_axiu_user0_data_V_strb_V int 8 regular {axi_s 1 volatile  { o_axiu_user0_data Strb } }  }
	{ o_axiu_user0_data_V_last_V int 1 regular {axi_s 1 volatile  { o_axiu_user0_data Last } }  }
	{ C_MATRIX int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_4 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_8 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_12 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_16 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_20 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_24 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_28 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_1 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_5 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_9 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_13 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_17 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_21 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_25 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_29 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_2 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_6 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_10 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_14 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_18 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_22 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_26 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_30 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_3 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_7 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_11 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_15 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_19 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_23 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_27 int 16 regular {array 32 { 1 3 } 1 1 }  }
	{ C_MATRIX_31 int 16 regular {array 32 { 1 3 } 1 1 }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read4", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read5", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read6", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "p_read7", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "WRITEONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "C_MATRIX", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_4", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_8", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_12", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_16", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_20", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_24", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_28", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_1", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_5", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_9", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_13", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_17", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_21", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_25", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_29", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_2", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_6", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_10", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_14", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_18", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_22", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_26", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_30", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_3", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_7", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_11", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_15", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_19", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_23", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_27", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "C_MATRIX_31", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 117
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ o_axiu_user0_data_TREADY sc_in sc_logic 1 outacc 11 } 
	{ p_read sc_in sc_lv 8 signal 0 } 
	{ p_read1 sc_in sc_lv 8 signal 1 } 
	{ p_read2 sc_in sc_lv 8 signal 2 } 
	{ p_read3 sc_in sc_lv 8 signal 3 } 
	{ p_read4 sc_in sc_lv 8 signal 4 } 
	{ p_read5 sc_in sc_lv 8 signal 5 } 
	{ p_read6 sc_in sc_lv 8 signal 6 } 
	{ p_read7 sc_in sc_lv 8 signal 7 } 
	{ o_axiu_user0_data_TDATA sc_out sc_lv 64 signal 8 } 
	{ o_axiu_user0_data_TVALID sc_out sc_logic 1 outvld 11 } 
	{ o_axiu_user0_data_TKEEP sc_out sc_lv 8 signal 9 } 
	{ o_axiu_user0_data_TSTRB sc_out sc_lv 8 signal 10 } 
	{ o_axiu_user0_data_TLAST sc_out sc_lv 1 signal 11 } 
	{ C_MATRIX_address0 sc_out sc_lv 5 signal 12 } 
	{ C_MATRIX_ce0 sc_out sc_logic 1 signal 12 } 
	{ C_MATRIX_q0 sc_in sc_lv 16 signal 12 } 
	{ C_MATRIX_4_address0 sc_out sc_lv 5 signal 13 } 
	{ C_MATRIX_4_ce0 sc_out sc_logic 1 signal 13 } 
	{ C_MATRIX_4_q0 sc_in sc_lv 16 signal 13 } 
	{ C_MATRIX_8_address0 sc_out sc_lv 5 signal 14 } 
	{ C_MATRIX_8_ce0 sc_out sc_logic 1 signal 14 } 
	{ C_MATRIX_8_q0 sc_in sc_lv 16 signal 14 } 
	{ C_MATRIX_12_address0 sc_out sc_lv 5 signal 15 } 
	{ C_MATRIX_12_ce0 sc_out sc_logic 1 signal 15 } 
	{ C_MATRIX_12_q0 sc_in sc_lv 16 signal 15 } 
	{ C_MATRIX_16_address0 sc_out sc_lv 5 signal 16 } 
	{ C_MATRIX_16_ce0 sc_out sc_logic 1 signal 16 } 
	{ C_MATRIX_16_q0 sc_in sc_lv 16 signal 16 } 
	{ C_MATRIX_20_address0 sc_out sc_lv 5 signal 17 } 
	{ C_MATRIX_20_ce0 sc_out sc_logic 1 signal 17 } 
	{ C_MATRIX_20_q0 sc_in sc_lv 16 signal 17 } 
	{ C_MATRIX_24_address0 sc_out sc_lv 5 signal 18 } 
	{ C_MATRIX_24_ce0 sc_out sc_logic 1 signal 18 } 
	{ C_MATRIX_24_q0 sc_in sc_lv 16 signal 18 } 
	{ C_MATRIX_28_address0 sc_out sc_lv 5 signal 19 } 
	{ C_MATRIX_28_ce0 sc_out sc_logic 1 signal 19 } 
	{ C_MATRIX_28_q0 sc_in sc_lv 16 signal 19 } 
	{ C_MATRIX_1_address0 sc_out sc_lv 5 signal 20 } 
	{ C_MATRIX_1_ce0 sc_out sc_logic 1 signal 20 } 
	{ C_MATRIX_1_q0 sc_in sc_lv 16 signal 20 } 
	{ C_MATRIX_5_address0 sc_out sc_lv 5 signal 21 } 
	{ C_MATRIX_5_ce0 sc_out sc_logic 1 signal 21 } 
	{ C_MATRIX_5_q0 sc_in sc_lv 16 signal 21 } 
	{ C_MATRIX_9_address0 sc_out sc_lv 5 signal 22 } 
	{ C_MATRIX_9_ce0 sc_out sc_logic 1 signal 22 } 
	{ C_MATRIX_9_q0 sc_in sc_lv 16 signal 22 } 
	{ C_MATRIX_13_address0 sc_out sc_lv 5 signal 23 } 
	{ C_MATRIX_13_ce0 sc_out sc_logic 1 signal 23 } 
	{ C_MATRIX_13_q0 sc_in sc_lv 16 signal 23 } 
	{ C_MATRIX_17_address0 sc_out sc_lv 5 signal 24 } 
	{ C_MATRIX_17_ce0 sc_out sc_logic 1 signal 24 } 
	{ C_MATRIX_17_q0 sc_in sc_lv 16 signal 24 } 
	{ C_MATRIX_21_address0 sc_out sc_lv 5 signal 25 } 
	{ C_MATRIX_21_ce0 sc_out sc_logic 1 signal 25 } 
	{ C_MATRIX_21_q0 sc_in sc_lv 16 signal 25 } 
	{ C_MATRIX_25_address0 sc_out sc_lv 5 signal 26 } 
	{ C_MATRIX_25_ce0 sc_out sc_logic 1 signal 26 } 
	{ C_MATRIX_25_q0 sc_in sc_lv 16 signal 26 } 
	{ C_MATRIX_29_address0 sc_out sc_lv 5 signal 27 } 
	{ C_MATRIX_29_ce0 sc_out sc_logic 1 signal 27 } 
	{ C_MATRIX_29_q0 sc_in sc_lv 16 signal 27 } 
	{ C_MATRIX_2_address0 sc_out sc_lv 5 signal 28 } 
	{ C_MATRIX_2_ce0 sc_out sc_logic 1 signal 28 } 
	{ C_MATRIX_2_q0 sc_in sc_lv 16 signal 28 } 
	{ C_MATRIX_6_address0 sc_out sc_lv 5 signal 29 } 
	{ C_MATRIX_6_ce0 sc_out sc_logic 1 signal 29 } 
	{ C_MATRIX_6_q0 sc_in sc_lv 16 signal 29 } 
	{ C_MATRIX_10_address0 sc_out sc_lv 5 signal 30 } 
	{ C_MATRIX_10_ce0 sc_out sc_logic 1 signal 30 } 
	{ C_MATRIX_10_q0 sc_in sc_lv 16 signal 30 } 
	{ C_MATRIX_14_address0 sc_out sc_lv 5 signal 31 } 
	{ C_MATRIX_14_ce0 sc_out sc_logic 1 signal 31 } 
	{ C_MATRIX_14_q0 sc_in sc_lv 16 signal 31 } 
	{ C_MATRIX_18_address0 sc_out sc_lv 5 signal 32 } 
	{ C_MATRIX_18_ce0 sc_out sc_logic 1 signal 32 } 
	{ C_MATRIX_18_q0 sc_in sc_lv 16 signal 32 } 
	{ C_MATRIX_22_address0 sc_out sc_lv 5 signal 33 } 
	{ C_MATRIX_22_ce0 sc_out sc_logic 1 signal 33 } 
	{ C_MATRIX_22_q0 sc_in sc_lv 16 signal 33 } 
	{ C_MATRIX_26_address0 sc_out sc_lv 5 signal 34 } 
	{ C_MATRIX_26_ce0 sc_out sc_logic 1 signal 34 } 
	{ C_MATRIX_26_q0 sc_in sc_lv 16 signal 34 } 
	{ C_MATRIX_30_address0 sc_out sc_lv 5 signal 35 } 
	{ C_MATRIX_30_ce0 sc_out sc_logic 1 signal 35 } 
	{ C_MATRIX_30_q0 sc_in sc_lv 16 signal 35 } 
	{ C_MATRIX_3_address0 sc_out sc_lv 5 signal 36 } 
	{ C_MATRIX_3_ce0 sc_out sc_logic 1 signal 36 } 
	{ C_MATRIX_3_q0 sc_in sc_lv 16 signal 36 } 
	{ C_MATRIX_7_address0 sc_out sc_lv 5 signal 37 } 
	{ C_MATRIX_7_ce0 sc_out sc_logic 1 signal 37 } 
	{ C_MATRIX_7_q0 sc_in sc_lv 16 signal 37 } 
	{ C_MATRIX_11_address0 sc_out sc_lv 5 signal 38 } 
	{ C_MATRIX_11_ce0 sc_out sc_logic 1 signal 38 } 
	{ C_MATRIX_11_q0 sc_in sc_lv 16 signal 38 } 
	{ C_MATRIX_15_address0 sc_out sc_lv 5 signal 39 } 
	{ C_MATRIX_15_ce0 sc_out sc_logic 1 signal 39 } 
	{ C_MATRIX_15_q0 sc_in sc_lv 16 signal 39 } 
	{ C_MATRIX_19_address0 sc_out sc_lv 5 signal 40 } 
	{ C_MATRIX_19_ce0 sc_out sc_logic 1 signal 40 } 
	{ C_MATRIX_19_q0 sc_in sc_lv 16 signal 40 } 
	{ C_MATRIX_23_address0 sc_out sc_lv 5 signal 41 } 
	{ C_MATRIX_23_ce0 sc_out sc_logic 1 signal 41 } 
	{ C_MATRIX_23_q0 sc_in sc_lv 16 signal 41 } 
	{ C_MATRIX_27_address0 sc_out sc_lv 5 signal 42 } 
	{ C_MATRIX_27_ce0 sc_out sc_logic 1 signal 42 } 
	{ C_MATRIX_27_q0 sc_in sc_lv 16 signal 42 } 
	{ C_MATRIX_31_address0 sc_out sc_lv 5 signal 43 } 
	{ C_MATRIX_31_ce0 sc_out sc_logic 1 signal 43 } 
	{ C_MATRIX_31_q0 sc_in sc_lv 16 signal 43 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "o_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "p_read1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read1", "role": "default" }} , 
 	{ "name": "p_read2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read2", "role": "default" }} , 
 	{ "name": "p_read3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read3", "role": "default" }} , 
 	{ "name": "p_read4", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read4", "role": "default" }} , 
 	{ "name": "p_read5", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read5", "role": "default" }} , 
 	{ "name": "p_read6", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read6", "role": "default" }} , 
 	{ "name": "p_read7", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "p_read7", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_data_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "o_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_keep_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_strb_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "C_MATRIX_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX", "role": "address0" }} , 
 	{ "name": "C_MATRIX_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX", "role": "q0" }} , 
 	{ "name": "C_MATRIX_4_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_4", "role": "address0" }} , 
 	{ "name": "C_MATRIX_4_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_4", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_4_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_4", "role": "q0" }} , 
 	{ "name": "C_MATRIX_8_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_8", "role": "address0" }} , 
 	{ "name": "C_MATRIX_8_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_8", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_8_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_8", "role": "q0" }} , 
 	{ "name": "C_MATRIX_12_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_12", "role": "address0" }} , 
 	{ "name": "C_MATRIX_12_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_12", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_12_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_12", "role": "q0" }} , 
 	{ "name": "C_MATRIX_16_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_16", "role": "address0" }} , 
 	{ "name": "C_MATRIX_16_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_16", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_16_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_16", "role": "q0" }} , 
 	{ "name": "C_MATRIX_20_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_20", "role": "address0" }} , 
 	{ "name": "C_MATRIX_20_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_20", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_20_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_20", "role": "q0" }} , 
 	{ "name": "C_MATRIX_24_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_24", "role": "address0" }} , 
 	{ "name": "C_MATRIX_24_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_24", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_24_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_24", "role": "q0" }} , 
 	{ "name": "C_MATRIX_28_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_28", "role": "address0" }} , 
 	{ "name": "C_MATRIX_28_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_28", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_28_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_28", "role": "q0" }} , 
 	{ "name": "C_MATRIX_1_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_1", "role": "address0" }} , 
 	{ "name": "C_MATRIX_1_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_1", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_1_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_1", "role": "q0" }} , 
 	{ "name": "C_MATRIX_5_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_5", "role": "address0" }} , 
 	{ "name": "C_MATRIX_5_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_5", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_5_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_5", "role": "q0" }} , 
 	{ "name": "C_MATRIX_9_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_9", "role": "address0" }} , 
 	{ "name": "C_MATRIX_9_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_9", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_9_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_9", "role": "q0" }} , 
 	{ "name": "C_MATRIX_13_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_13", "role": "address0" }} , 
 	{ "name": "C_MATRIX_13_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_13", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_13_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_13", "role": "q0" }} , 
 	{ "name": "C_MATRIX_17_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_17", "role": "address0" }} , 
 	{ "name": "C_MATRIX_17_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_17", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_17_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_17", "role": "q0" }} , 
 	{ "name": "C_MATRIX_21_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_21", "role": "address0" }} , 
 	{ "name": "C_MATRIX_21_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_21", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_21_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_21", "role": "q0" }} , 
 	{ "name": "C_MATRIX_25_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_25", "role": "address0" }} , 
 	{ "name": "C_MATRIX_25_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_25", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_25_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_25", "role": "q0" }} , 
 	{ "name": "C_MATRIX_29_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_29", "role": "address0" }} , 
 	{ "name": "C_MATRIX_29_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_29", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_29_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_29", "role": "q0" }} , 
 	{ "name": "C_MATRIX_2_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_2", "role": "address0" }} , 
 	{ "name": "C_MATRIX_2_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_2", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_2_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_2", "role": "q0" }} , 
 	{ "name": "C_MATRIX_6_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_6", "role": "address0" }} , 
 	{ "name": "C_MATRIX_6_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_6", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_6_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_6", "role": "q0" }} , 
 	{ "name": "C_MATRIX_10_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_10", "role": "address0" }} , 
 	{ "name": "C_MATRIX_10_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_10", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_10_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_10", "role": "q0" }} , 
 	{ "name": "C_MATRIX_14_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_14", "role": "address0" }} , 
 	{ "name": "C_MATRIX_14_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_14", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_14_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_14", "role": "q0" }} , 
 	{ "name": "C_MATRIX_18_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_18", "role": "address0" }} , 
 	{ "name": "C_MATRIX_18_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_18", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_18_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_18", "role": "q0" }} , 
 	{ "name": "C_MATRIX_22_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_22", "role": "address0" }} , 
 	{ "name": "C_MATRIX_22_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_22", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_22_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_22", "role": "q0" }} , 
 	{ "name": "C_MATRIX_26_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_26", "role": "address0" }} , 
 	{ "name": "C_MATRIX_26_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_26", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_26_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_26", "role": "q0" }} , 
 	{ "name": "C_MATRIX_30_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_30", "role": "address0" }} , 
 	{ "name": "C_MATRIX_30_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_30", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_30_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_30", "role": "q0" }} , 
 	{ "name": "C_MATRIX_3_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_3", "role": "address0" }} , 
 	{ "name": "C_MATRIX_3_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_3", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_3_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_3", "role": "q0" }} , 
 	{ "name": "C_MATRIX_7_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_7", "role": "address0" }} , 
 	{ "name": "C_MATRIX_7_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_7", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_7_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_7", "role": "q0" }} , 
 	{ "name": "C_MATRIX_11_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_11", "role": "address0" }} , 
 	{ "name": "C_MATRIX_11_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_11", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_11_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_11", "role": "q0" }} , 
 	{ "name": "C_MATRIX_15_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_15", "role": "address0" }} , 
 	{ "name": "C_MATRIX_15_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_15", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_15_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_15", "role": "q0" }} , 
 	{ "name": "C_MATRIX_19_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_19", "role": "address0" }} , 
 	{ "name": "C_MATRIX_19_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_19", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_19_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_19", "role": "q0" }} , 
 	{ "name": "C_MATRIX_23_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_23", "role": "address0" }} , 
 	{ "name": "C_MATRIX_23_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_23", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_23_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_23", "role": "q0" }} , 
 	{ "name": "C_MATRIX_27_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_27", "role": "address0" }} , 
 	{ "name": "C_MATRIX_27_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_27", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_27_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_27", "role": "q0" }} , 
 	{ "name": "C_MATRIX_31_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "C_MATRIX_31", "role": "address0" }} , 
 	{ "name": "C_MATRIX_31_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "C_MATRIX_31", "role": "ce0" }} , 
 	{ "name": "C_MATRIX_31_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "C_MATRIX_31", "role": "q0" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
		"CDFG" : "Loop_LOOP_OUTPUT_ALL_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "261", "EstimateLatencyMax" : "261",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "p_read4", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "p_read5", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "p_read6", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "p_read7", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "3", "DependentChanType" : "1"},
			{"Name" : "o_axiu_user0_data_V_data_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data",
				"BlockSignal" : [
					{"Name" : "o_axiu_user0_data_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "o_axiu_user0_data_V_keep_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data"},
			{"Name" : "o_axiu_user0_data_V_strb_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data"},
			{"Name" : "o_axiu_user0_data_V_last_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data"},
			{"Name" : "C_MATRIX", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_4", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_8", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_12", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_16", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_20", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_24", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_28", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_1", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_5", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_9", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_13", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_17", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_21", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_25", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_29", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_2", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_6", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_10", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_14", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_18", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_22", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_26", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_30", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_3", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_7", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_11", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_15", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_19", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_23", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_27", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "C_MATRIX_31", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"}],
		"Loop" : [
			{"Name" : "LOOP_OUTPUT_ALL", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter3", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter3", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mux_83_16_1_1_U2165", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mux_83_16_1_1_U2166", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mux_83_16_1_1_U2167", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mux_83_16_1_1_U2168", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_U", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_o_axiu_user0_data_V_data_V_U", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_o_axiu_user0_data_V_keep_V_U", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_o_axiu_user0_data_V_strb_V_U", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_o_axiu_user0_data_V_last_V_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	Loop_LOOP_OUTPUT_ALL_proc {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		p_read4 {Type I LastRead 0 FirstWrite -1}
		p_read5 {Type I LastRead 0 FirstWrite -1}
		p_read6 {Type I LastRead 0 FirstWrite -1}
		p_read7 {Type I LastRead 0 FirstWrite -1}
		o_axiu_user0_data_V_data_V {Type O LastRead -1 FirstWrite 2}
		o_axiu_user0_data_V_keep_V {Type O LastRead -1 FirstWrite 2}
		o_axiu_user0_data_V_strb_V {Type O LastRead -1 FirstWrite 2}
		o_axiu_user0_data_V_last_V {Type O LastRead -1 FirstWrite 2}
		C_MATRIX {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_4 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_8 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_12 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_16 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_20 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_24 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_28 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_1 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_5 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_9 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_13 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_17 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_21 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_25 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_29 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_2 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_6 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_10 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_14 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_18 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_22 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_26 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_30 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_3 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_7 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_11 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_15 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_19 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_23 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_27 {Type I LastRead 1 FirstWrite -1}
		C_MATRIX_31 {Type I LastRead 1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "261", "Max" : "261"}
	, {"Name" : "Interval", "Min" : "261", "Max" : "261"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	p_read { ap_none {  { p_read in_data 0 8 } } }
	p_read1 { ap_none {  { p_read1 in_data 0 8 } } }
	p_read2 { ap_none {  { p_read2 in_data 0 8 } } }
	p_read3 { ap_none {  { p_read3 in_data 0 8 } } }
	p_read4 { ap_none {  { p_read4 in_data 0 8 } } }
	p_read5 { ap_none {  { p_read5 in_data 0 8 } } }
	p_read6 { ap_none {  { p_read6 in_data 0 8 } } }
	p_read7 { ap_none {  { p_read7 in_data 0 8 } } }
	o_axiu_user0_data_V_data_V { axis {  { o_axiu_user0_data_TREADY out_acc 0 1 }  { o_axiu_user0_data_TDATA out_data 1 64 } } }
	o_axiu_user0_data_V_keep_V { axis {  { o_axiu_user0_data_TKEEP out_data 1 8 } } }
	o_axiu_user0_data_V_strb_V { axis {  { o_axiu_user0_data_TSTRB out_data 1 8 } } }
	o_axiu_user0_data_V_last_V { axis {  { o_axiu_user0_data_TVALID out_vld 1 1 }  { o_axiu_user0_data_TLAST out_data 1 1 } } }
	C_MATRIX { ap_memory {  { C_MATRIX_address0 mem_address 1 5 }  { C_MATRIX_ce0 mem_ce 1 1 }  { C_MATRIX_q0 in_data 0 16 } } }
	C_MATRIX_4 { ap_memory {  { C_MATRIX_4_address0 mem_address 1 5 }  { C_MATRIX_4_ce0 mem_ce 1 1 }  { C_MATRIX_4_q0 in_data 0 16 } } }
	C_MATRIX_8 { ap_memory {  { C_MATRIX_8_address0 mem_address 1 5 }  { C_MATRIX_8_ce0 mem_ce 1 1 }  { C_MATRIX_8_q0 in_data 0 16 } } }
	C_MATRIX_12 { ap_memory {  { C_MATRIX_12_address0 mem_address 1 5 }  { C_MATRIX_12_ce0 mem_ce 1 1 }  { C_MATRIX_12_q0 in_data 0 16 } } }
	C_MATRIX_16 { ap_memory {  { C_MATRIX_16_address0 mem_address 1 5 }  { C_MATRIX_16_ce0 mem_ce 1 1 }  { C_MATRIX_16_q0 in_data 0 16 } } }
	C_MATRIX_20 { ap_memory {  { C_MATRIX_20_address0 mem_address 1 5 }  { C_MATRIX_20_ce0 mem_ce 1 1 }  { C_MATRIX_20_q0 in_data 0 16 } } }
	C_MATRIX_24 { ap_memory {  { C_MATRIX_24_address0 mem_address 1 5 }  { C_MATRIX_24_ce0 mem_ce 1 1 }  { C_MATRIX_24_q0 in_data 0 16 } } }
	C_MATRIX_28 { ap_memory {  { C_MATRIX_28_address0 mem_address 1 5 }  { C_MATRIX_28_ce0 mem_ce 1 1 }  { C_MATRIX_28_q0 in_data 0 16 } } }
	C_MATRIX_1 { ap_memory {  { C_MATRIX_1_address0 mem_address 1 5 }  { C_MATRIX_1_ce0 mem_ce 1 1 }  { C_MATRIX_1_q0 in_data 0 16 } } }
	C_MATRIX_5 { ap_memory {  { C_MATRIX_5_address0 mem_address 1 5 }  { C_MATRIX_5_ce0 mem_ce 1 1 }  { C_MATRIX_5_q0 in_data 0 16 } } }
	C_MATRIX_9 { ap_memory {  { C_MATRIX_9_address0 mem_address 1 5 }  { C_MATRIX_9_ce0 mem_ce 1 1 }  { C_MATRIX_9_q0 in_data 0 16 } } }
	C_MATRIX_13 { ap_memory {  { C_MATRIX_13_address0 mem_address 1 5 }  { C_MATRIX_13_ce0 mem_ce 1 1 }  { C_MATRIX_13_q0 in_data 0 16 } } }
	C_MATRIX_17 { ap_memory {  { C_MATRIX_17_address0 mem_address 1 5 }  { C_MATRIX_17_ce0 mem_ce 1 1 }  { C_MATRIX_17_q0 in_data 0 16 } } }
	C_MATRIX_21 { ap_memory {  { C_MATRIX_21_address0 mem_address 1 5 }  { C_MATRIX_21_ce0 mem_ce 1 1 }  { C_MATRIX_21_q0 in_data 0 16 } } }
	C_MATRIX_25 { ap_memory {  { C_MATRIX_25_address0 mem_address 1 5 }  { C_MATRIX_25_ce0 mem_ce 1 1 }  { C_MATRIX_25_q0 in_data 0 16 } } }
	C_MATRIX_29 { ap_memory {  { C_MATRIX_29_address0 mem_address 1 5 }  { C_MATRIX_29_ce0 mem_ce 1 1 }  { C_MATRIX_29_q0 in_data 0 16 } } }
	C_MATRIX_2 { ap_memory {  { C_MATRIX_2_address0 mem_address 1 5 }  { C_MATRIX_2_ce0 mem_ce 1 1 }  { C_MATRIX_2_q0 in_data 0 16 } } }
	C_MATRIX_6 { ap_memory {  { C_MATRIX_6_address0 mem_address 1 5 }  { C_MATRIX_6_ce0 mem_ce 1 1 }  { C_MATRIX_6_q0 in_data 0 16 } } }
	C_MATRIX_10 { ap_memory {  { C_MATRIX_10_address0 mem_address 1 5 }  { C_MATRIX_10_ce0 mem_ce 1 1 }  { C_MATRIX_10_q0 in_data 0 16 } } }
	C_MATRIX_14 { ap_memory {  { C_MATRIX_14_address0 mem_address 1 5 }  { C_MATRIX_14_ce0 mem_ce 1 1 }  { C_MATRIX_14_q0 in_data 0 16 } } }
	C_MATRIX_18 { ap_memory {  { C_MATRIX_18_address0 mem_address 1 5 }  { C_MATRIX_18_ce0 mem_ce 1 1 }  { C_MATRIX_18_q0 in_data 0 16 } } }
	C_MATRIX_22 { ap_memory {  { C_MATRIX_22_address0 mem_address 1 5 }  { C_MATRIX_22_ce0 mem_ce 1 1 }  { C_MATRIX_22_q0 in_data 0 16 } } }
	C_MATRIX_26 { ap_memory {  { C_MATRIX_26_address0 mem_address 1 5 }  { C_MATRIX_26_ce0 mem_ce 1 1 }  { C_MATRIX_26_q0 in_data 0 16 } } }
	C_MATRIX_30 { ap_memory {  { C_MATRIX_30_address0 mem_address 1 5 }  { C_MATRIX_30_ce0 mem_ce 1 1 }  { C_MATRIX_30_q0 in_data 0 16 } } }
	C_MATRIX_3 { ap_memory {  { C_MATRIX_3_address0 mem_address 1 5 }  { C_MATRIX_3_ce0 mem_ce 1 1 }  { C_MATRIX_3_q0 in_data 0 16 } } }
	C_MATRIX_7 { ap_memory {  { C_MATRIX_7_address0 mem_address 1 5 }  { C_MATRIX_7_ce0 mem_ce 1 1 }  { C_MATRIX_7_q0 in_data 0 16 } } }
	C_MATRIX_11 { ap_memory {  { C_MATRIX_11_address0 mem_address 1 5 }  { C_MATRIX_11_ce0 mem_ce 1 1 }  { C_MATRIX_11_q0 in_data 0 16 } } }
	C_MATRIX_15 { ap_memory {  { C_MATRIX_15_address0 mem_address 1 5 }  { C_MATRIX_15_ce0 mem_ce 1 1 }  { C_MATRIX_15_q0 in_data 0 16 } } }
	C_MATRIX_19 { ap_memory {  { C_MATRIX_19_address0 mem_address 1 5 }  { C_MATRIX_19_ce0 mem_ce 1 1 }  { C_MATRIX_19_q0 in_data 0 16 } } }
	C_MATRIX_23 { ap_memory {  { C_MATRIX_23_address0 mem_address 1 5 }  { C_MATRIX_23_ce0 mem_ce 1 1 }  { C_MATRIX_23_q0 in_data 0 16 } } }
	C_MATRIX_27 { ap_memory {  { C_MATRIX_27_address0 mem_address 1 5 }  { C_MATRIX_27_ce0 mem_ce 1 1 }  { C_MATRIX_27_q0 in_data 0 16 } } }
	C_MATRIX_31 { ap_memory {  { C_MATRIX_31_address0 mem_address 1 5 }  { C_MATRIX_31_ce0 mem_ce 1 1 }  { C_MATRIX_31_q0 in_data 0 16 } } }
}
