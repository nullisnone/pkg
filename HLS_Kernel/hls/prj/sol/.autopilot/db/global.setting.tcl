
set TopModule "yusur_hash_allocation"
set ClockPeriod 3.5
set ClockList ap_clk
set HasVivadoClockPeriod 0
set CombLogicFlag 0
set PipelineFlag 1
set DataflowTaskPipelineFlag 1
set TrivialPipelineFlag 0
set noPortSwitchingFlag 0
set FloatingPointFlag 0
set FftOrFirFlag 0
set NbRWValue 1
set intNbAccess 1
set NewDSPMapping 1
set HasDSPModule 1
set ResetLevelFlag 0
set ResetStyle control
set ResetSyncFlag 1
set ResetRegisterFlag 0
set ResetVariableFlag 0
set ResetRegisterNum 0
set FsmEncStyle onehot
set MaxFanout 0
set RtlPrefix {}
set RtlSubPrefix yusur_hash_allocation_
set ExtraCCFlags {}
set ExtraCLdFlags {}
set SynCheckOptions {}
set PresynOptions {}
set PreprocOptions {}
set SchedOptions {}
set BindOptions {}
set RtlGenOptions {}
set RtlWriterOptions {}
set CbcGenFlag {}
set CasGenFlag {}
set CasMonitorFlag {}
set AutoSimOptions {}
set ExportMCPathFlag 0
set SCTraceFileName mytrace
set SCTraceFileFormat vcd
set SCTraceOption all
set TargetInfo xcku15p_CIV:-ffve1517:-2-e
set SourceFiles {sc {} c /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/HLS_Kernel/hls/../kernel/yusur_hash_allocation.cpp}
set SourceFlags {sc {} c -I/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/HLS_Kernel/hls/../kernel/kernel}
set DirectiveFile /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/HLS_Kernel/hls/prj/sol/sol.directive
set TBFiles {verilog /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/HLS_Kernel/hls/..//host/main.cpp bc /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/HLS_Kernel/hls/..//host/main.cpp vhdl /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/HLS_Kernel/hls/..//host/main.cpp sc /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/HLS_Kernel/hls/..//host/main.cpp cas /root/DOWNLOAD/SWIFT/pkg-20260220/pkg/HLS_Kernel/hls/..//host/main.cpp c {}}
set SpecLanguage C
set TVInFiles {bc {} c {} sc {} cas {} vhdl {} verilog {}}
set TVOutFiles {bc {} c {} sc {} cas {} vhdl {} verilog {}}
set TBTops {verilog {} bc {} vhdl {} sc {} cas {} c {}}
set TBInstNames {verilog {} bc {} vhdl {} sc {} cas {} c {}}
set XDCFiles {}
set ExtraGlobalOptions {"area_timing" 1 "clock_gate" 1 "impl_flow" map "power_gate" 0}
set TBTVFileNotFound {}
set AppFile ../hls.app
set ApsFile sol.aps
set AvePath ../..
set DefaultPlatform DefaultPlatform
set multiClockList {}
set SCPortClockMap {}
set intNbAccess 1
set PlatformFiles {{DefaultPlatform {xilinx/kintexuplus/kintexuplus}}}
set HPFPO 0
