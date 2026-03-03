set moduleName yusur_hash_allocation
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type dataflow
set FunctionProtocol ap_ctrl_none
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set C_modelName {yusur_hash_allocation}
set C_modelType { void 0 }
set C_modelArgList {
	{ i_axiu_key int 80 regular {axi_s 0 volatile  { i_axiu_key Data } }  }
	{ i_axiu_stream_data_V_data_V int 64 regular {axi_s 0 volatile  { i_axiu_stream_data Data } }  }
	{ i_axiu_stream_data_V_keep_V int 8 regular {axi_s 0 volatile  { i_axiu_stream_data Keep } }  }
	{ i_axiu_stream_data_V_strb_V int 8 regular {axi_s 0 volatile  { i_axiu_stream_data Strb } }  }
	{ i_axiu_stream_data_V_last_V int 1 regular {axi_s 0 volatile  { i_axiu_stream_data Last } }  }
	{ i_axiu_user0_data_V_data_V int 64 regular {axi_s 0 volatile  { i_axiu_user0_data Data } }  }
	{ i_axiu_user0_data_V_keep_V int 8 regular {axi_s 0 volatile  { i_axiu_user0_data Keep } }  }
	{ i_axiu_user0_data_V_strb_V int 8 regular {axi_s 0 volatile  { i_axiu_user0_data Strb } }  }
	{ i_axiu_user0_data_V_last_V int 1 regular {axi_s 0 volatile  { i_axiu_user0_data Last } }  }
	{ o_axiu_user0_data_V_data_V int 64 regular {axi_s 1 volatile  { o_axiu_user0_data Data } }  }
	{ o_axiu_user0_data_V_keep_V int 8 regular {axi_s 1 volatile  { o_axiu_user0_data Keep } }  }
	{ o_axiu_user0_data_V_strb_V int 8 regular {axi_s 1 volatile  { o_axiu_user0_data Strb } }  }
	{ o_axiu_user0_data_V_last_V int 1 regular {axi_s 1 volatile  { o_axiu_user0_data Last } }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "i_axiu_key", "interface" : "axis", "bitwidth" : 80, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_stream_data_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_stream_data_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_stream_data_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_stream_data_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_user0_data_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_user0_data_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_user0_data_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_user0_data_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "WRITEONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 23
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ i_axiu_key_TDATA sc_in sc_lv 80 signal 0 } 
	{ i_axiu_stream_data_TDATA sc_in sc_lv 64 signal 1 } 
	{ i_axiu_stream_data_TKEEP sc_in sc_lv 8 signal 2 } 
	{ i_axiu_stream_data_TSTRB sc_in sc_lv 8 signal 3 } 
	{ i_axiu_stream_data_TLAST sc_in sc_lv 1 signal 4 } 
	{ i_axiu_user0_data_TDATA sc_in sc_lv 64 signal 5 } 
	{ i_axiu_user0_data_TKEEP sc_in sc_lv 8 signal 6 } 
	{ i_axiu_user0_data_TSTRB sc_in sc_lv 8 signal 7 } 
	{ i_axiu_user0_data_TLAST sc_in sc_lv 1 signal 8 } 
	{ o_axiu_user0_data_TDATA sc_out sc_lv 64 signal 9 } 
	{ o_axiu_user0_data_TKEEP sc_out sc_lv 8 signal 10 } 
	{ o_axiu_user0_data_TSTRB sc_out sc_lv 8 signal 11 } 
	{ o_axiu_user0_data_TLAST sc_out sc_lv 1 signal 12 } 
	{ i_axiu_key_TVALID sc_in sc_logic 1 invld 0 } 
	{ i_axiu_key_TREADY sc_out sc_logic 1 inacc 0 } 
	{ i_axiu_stream_data_TVALID sc_in sc_logic 1 invld 4 } 
	{ i_axiu_stream_data_TREADY sc_out sc_logic 1 inacc 4 } 
	{ i_axiu_user0_data_TVALID sc_in sc_logic 1 invld 8 } 
	{ i_axiu_user0_data_TREADY sc_out sc_logic 1 inacc 8 } 
	{ o_axiu_user0_data_TVALID sc_out sc_logic 1 outvld 12 } 
	{ o_axiu_user0_data_TREADY sc_in sc_logic 1 outacc 12 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "i_axiu_key_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":80, "type": "signal", "bundle":{"name": "i_axiu_key", "role": "TDATA" }} , 
 	{ "name": "i_axiu_stream_data_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "i_axiu_stream_data_V_data_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "i_axiu_stream_data_V_keep_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "i_axiu_stream_data_V_strb_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "i_axiu_stream_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "i_axiu_user0_data_V_data_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "i_axiu_user0_data_V_keep_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "i_axiu_user0_data_V_strb_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "i_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_data_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_keep_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_strb_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_key_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "i_axiu_key", "role": "TVALID" }} , 
 	{ "name": "i_axiu_key_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "i_axiu_key", "role": "TREADY" }} , 
 	{ "name": "i_axiu_stream_data_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "i_axiu_stream_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "i_axiu_stream_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "i_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "i_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "o_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "o_axiu_user0_data_V_last_V", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "6", "16", "22"],
		"CDFG" : "yusur_hash_allocation",
		"Protocol" : "ap_ctrl_none",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0", "real_start" : "0",
		"Pipeline" : "Dataflow", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "-1", "EstimateLatencyMax" : "-1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "1",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"InputProcess" : [
			{"ID" : "4", "Name" : "Block_entry5_proc3_U0"},
			{"ID" : "6", "Name" : "Loop_VITIS_LOOP_105_1_proc4_U0"}],
		"OutputProcess" : [
			{"ID" : "4", "Name" : "Block_entry5_proc3_U0"},
			{"ID" : "16", "Name" : "Loop_LOOP_FORWARD_proc_U0"}],
		"Port" : [
			{"Name" : "i_axiu_key", "Type" : "Axis", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "4", "SubInstance" : "Block_entry5_proc3_U0", "Port" : "i_axiu_key"}]},
			{"Name" : "i_axiu_stream_data_V_data_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_stream_data",
				"SubConnect" : [
					{"ID" : "6", "SubInstance" : "Loop_VITIS_LOOP_105_1_proc4_U0", "Port" : "i_axiu_stream_data_V_data_V"}]},
			{"Name" : "i_axiu_stream_data_V_keep_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_stream_data",
				"SubConnect" : [
					{"ID" : "6", "SubInstance" : "Loop_VITIS_LOOP_105_1_proc4_U0", "Port" : "i_axiu_stream_data_V_keep_V"}]},
			{"Name" : "i_axiu_stream_data_V_strb_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_stream_data",
				"SubConnect" : [
					{"ID" : "6", "SubInstance" : "Loop_VITIS_LOOP_105_1_proc4_U0", "Port" : "i_axiu_stream_data_V_strb_V"}]},
			{"Name" : "i_axiu_stream_data_V_last_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_stream_data",
				"SubConnect" : [
					{"ID" : "6", "SubInstance" : "Loop_VITIS_LOOP_105_1_proc4_U0", "Port" : "i_axiu_stream_data_V_last_V"}]},
			{"Name" : "i_axiu_user0_data_V_data_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_user0_data",
				"SubConnect" : [
					{"ID" : "6", "SubInstance" : "Loop_VITIS_LOOP_105_1_proc4_U0", "Port" : "i_axiu_user0_data_V_data_V"}]},
			{"Name" : "i_axiu_user0_data_V_keep_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_user0_data",
				"SubConnect" : [
					{"ID" : "6", "SubInstance" : "Loop_VITIS_LOOP_105_1_proc4_U0", "Port" : "i_axiu_user0_data_V_keep_V"}]},
			{"Name" : "i_axiu_user0_data_V_strb_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_user0_data",
				"SubConnect" : [
					{"ID" : "6", "SubInstance" : "Loop_VITIS_LOOP_105_1_proc4_U0", "Port" : "i_axiu_user0_data_V_strb_V"}]},
			{"Name" : "i_axiu_user0_data_V_last_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_user0_data",
				"SubConnect" : [
					{"ID" : "6", "SubInstance" : "Loop_VITIS_LOOP_105_1_proc4_U0", "Port" : "i_axiu_user0_data_V_last_V"}]},
			{"Name" : "o_axiu_user0_data_V_data_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data",
				"SubConnect" : [
					{"ID" : "16", "SubInstance" : "Loop_LOOP_FORWARD_proc_U0", "Port" : "o_axiu_user0_data_V_data_V"}]},
			{"Name" : "o_axiu_user0_data_V_keep_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data",
				"SubConnect" : [
					{"ID" : "16", "SubInstance" : "Loop_LOOP_FORWARD_proc_U0", "Port" : "o_axiu_user0_data_V_keep_V"}]},
			{"Name" : "o_axiu_user0_data_V_strb_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data",
				"SubConnect" : [
					{"ID" : "16", "SubInstance" : "Loop_LOOP_FORWARD_proc_U0", "Port" : "o_axiu_user0_data_V_strb_V"}]},
			{"Name" : "o_axiu_user0_data_V_last_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data",
				"SubConnect" : [
					{"ID" : "16", "SubInstance" : "Loop_LOOP_FORWARD_proc_U0", "Port" : "o_axiu_user0_data_V_last_V"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.batch_data_V_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.keep_data_V_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.last_data_V_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Block_entry5_proc3_U0", "Parent" : "0", "Child" : ["5"],
		"CDFG" : "Block_entry5_proc3",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "i_axiu_key", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "i_axiu_key_TDATA_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "5", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Block_entry5_proc3_U0.regslice_both_i_axiu_key_U", "Parent" : "4"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0", "Parent" : "0", "Child" : ["7", "8", "9", "10", "11", "12", "13", "14", "15"],
		"CDFG" : "Loop_VITIS_LOOP_105_1_proc4",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "-1", "EstimateLatencyMax" : "-1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "1",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "i_axiu_stream_data_V_data_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_stream_data"},
			{"Name" : "i_axiu_stream_data_V_keep_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_stream_data"},
			{"Name" : "i_axiu_stream_data_V_strb_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_stream_data"},
			{"Name" : "i_axiu_stream_data_V_last_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_stream_data"},
			{"Name" : "i_axiu_user0_data_V_data_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_user0_data",
				"BlockSignal" : [
					{"Name" : "i_axiu_user0_data_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "i_axiu_user0_data_V_keep_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_user0_data"},
			{"Name" : "i_axiu_user0_data_V_strb_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_user0_data"},
			{"Name" : "i_axiu_user0_data_V_last_V", "Type" : "Axis", "Direction" : "I", "BaseName" : "i_axiu_user0_data"},
			{"Name" : "batch_data_V", "Type" : "Memory", "Direction" : "O", "DependentProc" : ["16"], "DependentChan" : "1"},
			{"Name" : "keep_data_V", "Type" : "Memory", "Direction" : "O", "DependentProc" : ["16"], "DependentChan" : "2"},
			{"Name" : "last_data_V", "Type" : "Memory", "Direction" : "O", "DependentProc" : ["16"], "DependentChan" : "3"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_105_1", "PipelineType" : "NotSupport"}]},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0.flow_control_loop_pipe_U", "Parent" : "6"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0.regslice_both_i_axiu_stream_data_V_data_V_U", "Parent" : "6"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0.regslice_both_i_axiu_stream_data_V_keep_V_U", "Parent" : "6"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0.regslice_both_i_axiu_stream_data_V_strb_V_U", "Parent" : "6"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0.regslice_both_i_axiu_stream_data_V_last_V_U", "Parent" : "6"},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0.regslice_both_i_axiu_user0_data_V_data_V_U", "Parent" : "6"},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0.regslice_both_i_axiu_user0_data_V_keep_V_U", "Parent" : "6"},
	{"ID" : "14", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0.regslice_both_i_axiu_user0_data_V_strb_V_U", "Parent" : "6"},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_VITIS_LOOP_105_1_proc4_U0.regslice_both_i_axiu_user0_data_V_last_V_U", "Parent" : "6"},
	{"ID" : "16", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Loop_LOOP_FORWARD_proc_U0", "Parent" : "0", "Child" : ["17", "18", "19", "20", "21"],
		"CDFG" : "Loop_LOOP_FORWARD_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "-1", "EstimateLatencyMax" : "-1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["6"], "DependentChan" : "22", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "batch_data_V", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["6"], "DependentChan" : "1"},
			{"Name" : "keep_data_V", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["6"], "DependentChan" : "2"},
			{"Name" : "last_data_V", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["6"], "DependentChan" : "3"},
			{"Name" : "o_axiu_user0_data_V_data_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data",
				"BlockSignal" : [
					{"Name" : "o_axiu_user0_data_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "o_axiu_user0_data_V_keep_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data"},
			{"Name" : "o_axiu_user0_data_V_strb_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data"},
			{"Name" : "o_axiu_user0_data_V_last_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data"}],
		"Loop" : [
			{"Name" : "LOOP_FORWARD", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter2", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_LOOP_FORWARD_proc_U0.flow_control_loop_pipe_U", "Parent" : "16"},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_LOOP_FORWARD_proc_U0.regslice_both_o_axiu_user0_data_V_data_V_U", "Parent" : "16"},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_LOOP_FORWARD_proc_U0.regslice_both_o_axiu_user0_data_V_keep_V_U", "Parent" : "16"},
	{"ID" : "20", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_LOOP_FORWARD_proc_U0.regslice_both_o_axiu_user0_data_V_strb_V_U", "Parent" : "16"},
	{"ID" : "21", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_LOOP_FORWARD_proc_U0.regslice_both_o_axiu_user0_data_V_last_V_U", "Parent" : "16"},
	{"ID" : "22", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.pkt_len_1_loc_channel_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	yusur_hash_allocation {
		i_axiu_key {Type I LastRead 0 FirstWrite -1}
		i_axiu_stream_data_V_data_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_stream_data_V_keep_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_stream_data_V_strb_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_stream_data_V_last_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_user0_data_V_data_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_user0_data_V_keep_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_user0_data_V_strb_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_user0_data_V_last_V {Type I LastRead 0 FirstWrite -1}
		o_axiu_user0_data_V_data_V {Type O LastRead -1 FirstWrite 1}
		o_axiu_user0_data_V_keep_V {Type O LastRead -1 FirstWrite 1}
		o_axiu_user0_data_V_strb_V {Type O LastRead -1 FirstWrite 1}
		o_axiu_user0_data_V_last_V {Type O LastRead -1 FirstWrite 1}}
	Block_entry5_proc3 {
		i_axiu_key {Type I LastRead 0 FirstWrite -1}}
	Loop_VITIS_LOOP_105_1_proc4 {
		i_axiu_stream_data_V_data_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_stream_data_V_keep_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_stream_data_V_strb_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_stream_data_V_last_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_user0_data_V_data_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_user0_data_V_keep_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_user0_data_V_strb_V {Type I LastRead 0 FirstWrite -1}
		i_axiu_user0_data_V_last_V {Type I LastRead 0 FirstWrite -1}
		batch_data_V {Type O LastRead -1 FirstWrite 0}
		keep_data_V {Type O LastRead -1 FirstWrite 0}
		last_data_V {Type O LastRead -1 FirstWrite 0}}
	Loop_LOOP_FORWARD_proc {
		p_read {Type I LastRead 0 FirstWrite -1}
		batch_data_V {Type I LastRead 0 FirstWrite -1}
		keep_data_V {Type I LastRead 0 FirstWrite -1}
		last_data_V {Type I LastRead 0 FirstWrite -1}
		o_axiu_user0_data_V_data_V {Type O LastRead -1 FirstWrite 1}
		o_axiu_user0_data_V_keep_V {Type O LastRead -1 FirstWrite 1}
		o_axiu_user0_data_V_strb_V {Type O LastRead -1 FirstWrite 1}
		o_axiu_user0_data_V_last_V {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "-1", "Max" : "-1"}
	, {"Name" : "Interval", "Min" : "-1", "Max" : "-1"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	i_axiu_key { axis {  { i_axiu_key_TDATA in_data 0 80 }  { i_axiu_key_TVALID in_vld 0 1 }  { i_axiu_key_TREADY in_acc 1 1 } } }
	i_axiu_stream_data_V_data_V { axis {  { i_axiu_stream_data_TDATA in_data 0 64 } } }
	i_axiu_stream_data_V_keep_V { axis {  { i_axiu_stream_data_TKEEP in_data 0 8 } } }
	i_axiu_stream_data_V_strb_V { axis {  { i_axiu_stream_data_TSTRB in_data 0 8 } } }
	i_axiu_stream_data_V_last_V { axis {  { i_axiu_stream_data_TLAST in_data 0 1 }  { i_axiu_stream_data_TVALID in_vld 0 1 }  { i_axiu_stream_data_TREADY in_acc 1 1 } } }
	i_axiu_user0_data_V_data_V { axis {  { i_axiu_user0_data_TDATA in_data 0 64 } } }
	i_axiu_user0_data_V_keep_V { axis {  { i_axiu_user0_data_TKEEP in_data 0 8 } } }
	i_axiu_user0_data_V_strb_V { axis {  { i_axiu_user0_data_TSTRB in_data 0 8 } } }
	i_axiu_user0_data_V_last_V { axis {  { i_axiu_user0_data_TLAST in_data 0 1 }  { i_axiu_user0_data_TVALID in_vld 0 1 }  { i_axiu_user0_data_TREADY in_acc 1 1 } } }
	o_axiu_user0_data_V_data_V { axis {  { o_axiu_user0_data_TDATA out_data 1 64 } } }
	o_axiu_user0_data_V_keep_V { axis {  { o_axiu_user0_data_TKEEP out_data 1 8 } } }
	o_axiu_user0_data_V_strb_V { axis {  { o_axiu_user0_data_TSTRB out_data 1 8 } } }
	o_axiu_user0_data_V_last_V { axis {  { o_axiu_user0_data_TLAST out_data 1 1 }  { o_axiu_user0_data_TVALID out_vld 1 1 }  { o_axiu_user0_data_TREADY out_acc 0 1 } } }
}

set maxi_interface_dict [dict create]

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
