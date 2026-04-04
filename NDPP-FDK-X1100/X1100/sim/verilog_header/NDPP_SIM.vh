//--------------------------------------------------------------------------------
//  __   ___   _ ____  _   _ ____       Project     : ndpp_sim
//  \ \ / / | | / ___|| | | |  _ \      File        : NDPP_SIM.vh
//   \ V /| | | \___ \| | | | |_) |     Version     : 0.0.1
//    | | | |_| |___) | |_| |  _ <      Author      : 
//    |_|  \___/|____/ \___/|_| \_\     Date        : 2024-01-01
//                                      Description : Verilog Header for NDPP Simulation Model
//--------------------------------------------------------------------------------
//------Verilog_Header(`define)
//      Please use the hump nomenclature to define the parameters, and declare the full information of the parameters.
//--------------------------------------------------------------------------------
//------Usage:
    // If user want to use this verilog-header file in user's modules, Please add the following instruction to the modules.
    //      eg.  `include "<path_to_vh>/NDPP_SIM.vh"
    // If user want to use other verilog-header files, Please add the following instructions in this module or other user's modules.
    //      eg.  `include "<path_to_vh>/USER.vh"

//--------------------------------------------------------------------------------
//------include
//`include "<path_to_vh>/SIM_PARAMETER.vh"
`include "SIM_PARAMETER.vh"

//--------------------------------------------------------------------------------
//------Mode
//---GLOBAL_MODE          :   defualt
`define GLOBAL_MODE
//`define LOCAL_MODE
//`define NORMAL_MODE
//`define DMA_LOOP_MDOE
//`define MAC_NORMAL_MDOE   // MAC0_TX -> , MAC1_TX -> , -> MAC0_RX , -> MAC1_RX , ...
//`define MAC_LOOP0_MDOE    // MAC0_TX -> MAC0_RX , MAC1_TX -> MAC1_RX , ...
//`define MAC_LOOP1_MDOE    // MAC0_TX -> MAC1_RX , MAC1_TX -> MAC0_RX , ...

//------MAC
//---AXIS_NORMAL_MAC      :   tvalid and tready are independent
//`define AXIS_NORMAL_MAC
//---AXIS_NDPP_MAC        :   tvalid must be high 1 cycle before tready is high
`ifndef AXIS_NORMAL_MAC
    `define AXIS_NDPP_MAC
`endif
//--------------------------------------------------------------------------------
//------Version
`define NDPP_SIM_VERSION        32'h2025_0305

`define NDPP_SIM_VERSION_STR    "NDPP_V1.1.0-@-2025.03.05"
    //`define NDPP_SIM_VERSION_STR    "NDPP_V1.0.5\
    //-@-\
    //2024.04.02"

//--------------------------------------------------------------------------------
//------




//------end