set moduleName Loop_VITIS_LOOP_105_1_proc4
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
set C_modelName {Loop_VITIS_LOOP_105_1_proc4}
set C_modelType { int 32 }
set C_modelArgList {
	{ i_axiu_stream_data_V_data_V int 64 regular {axi_s 0 volatile  { i_axiu_stream_data Data } }  }
	{ i_axiu_stream_data_V_keep_V int 8 regular {axi_s 0 volatile  { i_axiu_stream_data Keep } }  }
	{ i_axiu_stream_data_V_strb_V int 8 regular {axi_s 0 volatile  { i_axiu_stream_data Strb } }  }
	{ i_axiu_stream_data_V_last_V int 1 regular {axi_s 0 volatile  { i_axiu_stream_data Last } }  }
	{ i_axiu_user0_data_V_data_V int 64 regular {axi_s 0 volatile  { i_axiu_user0_data Data } }  }
	{ i_axiu_user0_data_V_keep_V int 8 regular {axi_s 0 volatile  { i_axiu_user0_data Keep } }  }
	{ i_axiu_user0_data_V_strb_V int 8 regular {axi_s 0 volatile  { i_axiu_user0_data Strb } }  }
	{ i_axiu_user0_data_V_last_V int 1 regular {axi_s 0 volatile  { i_axiu_user0_data Last } }  }
	{ batch_data_V int 64 regular {array 256 { 0 3 } 0 1 }  }
	{ keep_data_V int 8 regular {array 256 { 0 3 } 0 1 }  }
	{ last_data_V int 1 regular {array 256 { 0 3 } 0 1 }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "i_axiu_stream_data_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_stream_data_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_stream_data_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_stream_data_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_user0_data_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_user0_data_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_user0_data_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "i_axiu_user0_data_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "batch_data_V", "interface" : "memory", "bitwidth" : 64, "direction" : "WRITEONLY"} , 
 	{ "Name" : "keep_data_V", "interface" : "memory", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "last_data_V", "interface" : "memory", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "ap_return", "interface" : "wire", "bitwidth" : 32} ]}
# RTL Port declarations: 
set portNum 32
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ i_axiu_user0_data_TVALID sc_in sc_logic 1 invld 7 } 
	{ i_axiu_stream_data_TDATA sc_in sc_lv 64 signal 0 } 
	{ i_axiu_stream_data_TVALID sc_in sc_logic 1 invld 3 } 
	{ i_axiu_stream_data_TREADY sc_out sc_logic 1 inacc 3 } 
	{ i_axiu_stream_data_TKEEP sc_in sc_lv 8 signal 1 } 
	{ i_axiu_stream_data_TSTRB sc_in sc_lv 8 signal 2 } 
	{ i_axiu_stream_data_TLAST sc_in sc_lv 1 signal 3 } 
	{ i_axiu_user0_data_TDATA sc_in sc_lv 64 signal 4 } 
	{ i_axiu_user0_data_TREADY sc_out sc_logic 1 inacc 7 } 
	{ i_axiu_user0_data_TKEEP sc_in sc_lv 8 signal 5 } 
	{ i_axiu_user0_data_TSTRB sc_in sc_lv 8 signal 6 } 
	{ i_axiu_user0_data_TLAST sc_in sc_lv 1 signal 7 } 
	{ batch_data_V_address0 sc_out sc_lv 8 signal 8 } 
	{ batch_data_V_ce0 sc_out sc_logic 1 signal 8 } 
	{ batch_data_V_we0 sc_out sc_logic 1 signal 8 } 
	{ batch_data_V_d0 sc_out sc_lv 64 signal 8 } 
	{ keep_data_V_address0 sc_out sc_lv 8 signal 9 } 
	{ keep_data_V_ce0 sc_out sc_logic 1 signal 9 } 
	{ keep_data_V_we0 sc_out sc_logic 1 signal 9 } 
	{ keep_data_V_d0 sc_out sc_lv 8 signal 9 } 
	{ last_data_V_address0 sc_out sc_lv 8 signal 10 } 
	{ last_data_V_ce0 sc_out sc_logic 1 signal 10 } 
	{ last_data_V_we0 sc_out sc_logic 1 signal 10 } 
	{ last_data_V_d0 sc_out sc_lv 1 signal 10 } 
	{ ap_return sc_out sc_lv 32 signal -1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "i_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "i_axiu_stream_data_V_data_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "i_axiu_stream_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "i_axiu_stream_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "i_axiu_stream_data_V_keep_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "i_axiu_stream_data_V_strb_V", "role": "default" }} , 
 	{ "name": "i_axiu_stream_data_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "i_axiu_stream_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "i_axiu_user0_data_V_data_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "i_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "i_axiu_user0_data_V_keep_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "i_axiu_user0_data_V_strb_V", "role": "default" }} , 
 	{ "name": "i_axiu_user0_data_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "i_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "batch_data_V_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "batch_data_V", "role": "address0" }} , 
 	{ "name": "batch_data_V_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "batch_data_V", "role": "ce0" }} , 
 	{ "name": "batch_data_V_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "batch_data_V", "role": "we0" }} , 
 	{ "name": "batch_data_V_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "batch_data_V", "role": "d0" }} , 
 	{ "name": "keep_data_V_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "keep_data_V", "role": "address0" }} , 
 	{ "name": "keep_data_V_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "keep_data_V", "role": "ce0" }} , 
 	{ "name": "keep_data_V_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "keep_data_V", "role": "we0" }} , 
 	{ "name": "keep_data_V_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "keep_data_V", "role": "d0" }} , 
 	{ "name": "last_data_V_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "last_data_V", "role": "address0" }} , 
 	{ "name": "last_data_V_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "last_data_V", "role": "ce0" }} , 
 	{ "name": "last_data_V_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "last_data_V", "role": "we0" }} , 
 	{ "name": "last_data_V_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "last_data_V", "role": "d0" }} , 
 	{ "name": "ap_return", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ap_return", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
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
			{"Name" : "batch_data_V", "Type" : "Memory", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "keep_data_V", "Type" : "Memory", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "last_data_V", "Type" : "Memory", "Direction" : "O", "DependentProc" : ["0"], "DependentChan" : "0"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_105_1", "PipelineType" : "NotSupport"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_i_axiu_stream_data_V_data_V_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_i_axiu_stream_data_V_keep_V_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_i_axiu_stream_data_V_strb_V_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_i_axiu_stream_data_V_last_V_U", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_i_axiu_user0_data_V_data_V_U", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_i_axiu_user0_data_V_keep_V_U", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_i_axiu_user0_data_V_strb_V_U", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_i_axiu_user0_data_V_last_V_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
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
		last_data_V {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "-1", "Max" : "-1"}
	, {"Name" : "Interval", "Min" : "-1", "Max" : "-1"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	i_axiu_stream_data_V_data_V { axis {  { i_axiu_stream_data_TDATA in_data 0 64 } } }
	i_axiu_stream_data_V_keep_V { axis {  { i_axiu_stream_data_TKEEP in_data 0 8 } } }
	i_axiu_stream_data_V_strb_V { axis {  { i_axiu_stream_data_TSTRB in_data 0 8 } } }
	i_axiu_stream_data_V_last_V { axis {  { i_axiu_stream_data_TVALID in_vld 0 1 }  { i_axiu_stream_data_TREADY in_acc 1 1 }  { i_axiu_stream_data_TLAST in_data 0 1 } } }
	i_axiu_user0_data_V_data_V { axis {  { i_axiu_user0_data_TDATA in_data 0 64 } } }
	i_axiu_user0_data_V_keep_V { axis {  { i_axiu_user0_data_TKEEP in_data 0 8 } } }
	i_axiu_user0_data_V_strb_V { axis {  { i_axiu_user0_data_TSTRB in_data 0 8 } } }
	i_axiu_user0_data_V_last_V { axis {  { i_axiu_user0_data_TVALID in_vld 0 1 }  { i_axiu_user0_data_TREADY in_acc 1 1 }  { i_axiu_user0_data_TLAST in_data 0 1 } } }
	batch_data_V { ap_memory {  { batch_data_V_address0 mem_address 1 8 }  { batch_data_V_ce0 mem_ce 1 1 }  { batch_data_V_we0 mem_we 1 1 }  { batch_data_V_d0 mem_din 1 64 } } }
	keep_data_V { ap_memory {  { keep_data_V_address0 mem_address 1 8 }  { keep_data_V_ce0 mem_ce 1 1 }  { keep_data_V_we0 mem_we 1 1 }  { keep_data_V_d0 mem_din 1 8 } } }
	last_data_V { ap_memory {  { last_data_V_address0 mem_address 1 8 }  { last_data_V_ce0 mem_ce 1 1 }  { last_data_V_we0 mem_we 1 1 }  { last_data_V_d0 mem_din 1 1 } } }
}
