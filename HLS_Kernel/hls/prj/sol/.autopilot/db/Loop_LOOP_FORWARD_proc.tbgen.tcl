set moduleName Loop_LOOP_FORWARD_proc
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
set C_modelName {Loop_LOOP_FORWARD_proc}
set C_modelType { void 0 }
set C_modelArgList {
	{ p_read int 32 regular  }
	{ batch_data_V int 64 regular {array 256 { 1 3 } 1 1 }  }
	{ keep_data_V int 8 regular {array 256 { 1 3 } 1 1 }  }
	{ last_data_V int 1 regular {array 256 { 1 3 } 1 1 }  }
	{ o_axiu_user0_data_V_data_V int 64 regular {axi_s 1 volatile  { o_axiu_user0_data Data } }  }
	{ o_axiu_user0_data_V_keep_V int 8 regular {axi_s 1 volatile  { o_axiu_user0_data Keep } }  }
	{ o_axiu_user0_data_V_strb_V int 8 regular {axi_s 1 volatile  { o_axiu_user0_data Strb } }  }
	{ o_axiu_user0_data_V_last_V int 1 regular {axi_s 1 volatile  { o_axiu_user0_data Last } }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "p_read", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "batch_data_V", "interface" : "memory", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "keep_data_V", "interface" : "memory", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "last_data_V", "interface" : "memory", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "WRITEONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "WRITEONLY"} , 
 	{ "Name" : "o_axiu_user0_data_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 23
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ o_axiu_user0_data_TREADY sc_in sc_logic 1 outacc 7 } 
	{ p_read sc_in sc_lv 32 signal 0 } 
	{ batch_data_V_address0 sc_out sc_lv 8 signal 1 } 
	{ batch_data_V_ce0 sc_out sc_logic 1 signal 1 } 
	{ batch_data_V_q0 sc_in sc_lv 64 signal 1 } 
	{ keep_data_V_address0 sc_out sc_lv 8 signal 2 } 
	{ keep_data_V_ce0 sc_out sc_logic 1 signal 2 } 
	{ keep_data_V_q0 sc_in sc_lv 8 signal 2 } 
	{ last_data_V_address0 sc_out sc_lv 8 signal 3 } 
	{ last_data_V_ce0 sc_out sc_logic 1 signal 3 } 
	{ last_data_V_q0 sc_in sc_lv 1 signal 3 } 
	{ o_axiu_user0_data_TDATA sc_out sc_lv 64 signal 4 } 
	{ o_axiu_user0_data_TVALID sc_out sc_logic 1 outvld 7 } 
	{ o_axiu_user0_data_TKEEP sc_out sc_lv 8 signal 5 } 
	{ o_axiu_user0_data_TSTRB sc_out sc_lv 8 signal 6 } 
	{ o_axiu_user0_data_TLAST sc_out sc_lv 1 signal 7 } 
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
 	{ "name": "p_read", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_read", "role": "default" }} , 
 	{ "name": "batch_data_V_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "batch_data_V", "role": "address0" }} , 
 	{ "name": "batch_data_V_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "batch_data_V", "role": "ce0" }} , 
 	{ "name": "batch_data_V_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "batch_data_V", "role": "q0" }} , 
 	{ "name": "keep_data_V_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "keep_data_V", "role": "address0" }} , 
 	{ "name": "keep_data_V_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "keep_data_V", "role": "ce0" }} , 
 	{ "name": "keep_data_V_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "keep_data_V", "role": "q0" }} , 
 	{ "name": "last_data_V_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "last_data_V", "role": "address0" }} , 
 	{ "name": "last_data_V_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "last_data_V", "role": "ce0" }} , 
 	{ "name": "last_data_V_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "last_data_V", "role": "q0" }} , 
 	{ "name": "o_axiu_user0_data_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_data_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "o_axiu_user0_data_V_last_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_keep_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_strb_V", "role": "default" }} , 
 	{ "name": "o_axiu_user0_data_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "o_axiu_user0_data_V_last_V", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5"],
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
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "batch_data_V", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "keep_data_V", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "last_data_V", "Type" : "Memory", "Direction" : "I", "DependentProc" : ["0"], "DependentChan" : "0"},
			{"Name" : "o_axiu_user0_data_V_data_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data",
				"BlockSignal" : [
					{"Name" : "o_axiu_user0_data_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "o_axiu_user0_data_V_keep_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data"},
			{"Name" : "o_axiu_user0_data_V_strb_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data"},
			{"Name" : "o_axiu_user0_data_V_last_V", "Type" : "Axis", "Direction" : "O", "BaseName" : "o_axiu_user0_data"}],
		"Loop" : [
			{"Name" : "LOOP_FORWARD", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter2", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter2", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.flow_control_loop_pipe_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_o_axiu_user0_data_V_data_V_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_o_axiu_user0_data_V_keep_V_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_o_axiu_user0_data_V_strb_V_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_o_axiu_user0_data_V_last_V_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
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
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	p_read { ap_none {  { p_read in_data 0 32 } } }
	batch_data_V { ap_memory {  { batch_data_V_address0 mem_address 1 8 }  { batch_data_V_ce0 mem_ce 1 1 }  { batch_data_V_q0 in_data 0 64 } } }
	keep_data_V { ap_memory {  { keep_data_V_address0 mem_address 1 8 }  { keep_data_V_ce0 mem_ce 1 1 }  { keep_data_V_q0 in_data 0 8 } } }
	last_data_V { ap_memory {  { last_data_V_address0 mem_address 1 8 }  { last_data_V_ce0 mem_ce 1 1 }  { last_data_V_q0 in_data 0 1 } } }
	o_axiu_user0_data_V_data_V { axis {  { o_axiu_user0_data_TREADY out_acc 0 1 }  { o_axiu_user0_data_TDATA out_data 1 64 } } }
	o_axiu_user0_data_V_keep_V { axis {  { o_axiu_user0_data_TKEEP out_data 1 8 } } }
	o_axiu_user0_data_V_strb_V { axis {  { o_axiu_user0_data_TSTRB out_data 1 8 } } }
	o_axiu_user0_data_V_last_V { axis {  { o_axiu_user0_data_TVALID out_vld 1 1 }  { o_axiu_user0_data_TLAST out_data 1 1 } } }
}
