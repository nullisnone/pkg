//--------------------------------------------------------------------------------
//  __   ___   _ ____  _   _ ____       Project     : ndpp_sim
//  \ \ / / | | / ___|| | | |  _ \      File        : SIM_PARAMETER.vh
//   \ V /| | | \___ \| | | | |_) |     Version     : 0.0.1
//    | | | |_| |___) | |_| |  _ <      Author      : 
//    |_|  \___/|____/ \___/|_| \_\     Date        : 2024-01-01
//                                      Description : It's part of parameters for NDPP_SIM.vh
//--------------------------------------------------------------------------------
//------Verilog_Header(`define)
//      Please use the hump nomenclature to define the parameters, and declare the full information of the parameters.
//--------------------------------------------------------------------------------
//------Usage:
    // If user want to use this verilog-header file in NDPP_SIM.vh, Please add the following instruction in NDPP_SIM.vh.
    //      eg.  `include "<path_to_vh>/SIM_PARAMETER.vh"
    // If user want to use this verilog-header file in user's modules directly, Please add the following instructions to the modules.
    //      eg.  `include "<path_to_vh>/SIM_PARAMETER.vh"

//--------------------------------------------------------------------------------
//------`timescale
//---Usage:
//  timescale <time_unit>/<time_precision>
//    eg.  `timescale 1ns/1ps
//    eg.  `timescale 1ps/1ps

//`define GLOBAL_TIMESCALE
    `ifdef GLOBAL_TIMESCALE
        `define TIME_UNIT           100ps
        `define TIME_PRECISION      1ps
    `else
        `define TIME_UNIT           1ps
        `define TIME_PRECISION      1ps
    `endif
    
`define CLOCK_OFFSET         0  //
`define CLOCK_PERIOD        10  //10 * TIME_UNIT

    /*  `timescale `TIME_UNIT/`TIME_PRECISION  */
    /*  `define TIMESCALE           `timescale\ `TIME_UNIT/`TIME_PRECISION  */
//--------------------------------------------------------------------------------Parameter
//------Parameter
`define DATA_WIDTH_32       32
`define DATA_WIDTH_64       64
`define CLOCK_OFFSET         0  //
`define CLOCK_PERIOD        10  //10period
    
//---Usage:
//    reg   [`DATA_WIDTH_32-1 : 0] user_data_0    ;//32bit
//    reg   [`DATA_WIDTH_64-1 : 0] user_data_1    ;//64bit

//-------------------------------------------------------------------------------- $stop and $finish
//------SIM_INFO_LEVEL for $stop and $finish
    //---0: do not output any  information;
    //---1: outptu the current simulation time and position; //default
    //---2: output the current simulation time, location, memory and CPU time used during the simulation;
    //---3: output the current simulation time, location, memory and CPU time used during the simulation, and the number of simulation events. //not for verilog

`define SIM_INFO_LEVEL

    `ifndef SIM_INFO_LEVEL
        `define LEVEL_0     1
        `define LEVEL_1     1
        `define LEVEL_2     1
    `else
        `define LEVEL_0     0
        `define LEVEL_1     1
        `define LEVEL_2     2
    `endif

`define SIM_WARNING_LEVEL
    
//--------------------------------------------------------------------------------$time
    //------Usage:
    // If we want to display the time, we can use the following code.
    //      eg.  $timeformat(-6,5," ns",20);
    //      eg.  $timeformat(-3,5," ms",20);
    // Users can use diffrence mode of $time to display the time with `define and parameter for facilitate development.
    //      eg.  $timeformat(DISPLAY_UNIT,DISPLAY_FRACTION,DISPLAY_MESSAGE,DISPLAY_DEPTH);
    //------Define : milliseconds, microseconds, nanoseconds
    //`define           MS                                       //millisecond : 1 s = 1_000 ms
    `define             US                                       //microsecond : 1 s = 1_000_000 us         //default
    //`define           NS                                       //nanosecond  : 1 s = 1_000_000_000 ns
    //`define           FS                                       //femtosecond : 1 s = 1_000_000_000_000 fs
    //------Parameter : 
`ifdef US
	parameter           DISPLAY_UNIT        =   -6              ;//0 second, -3 ms, -6 us, -9 ns, -12 ps, -15 fs.
	parameter    	    DISPLAY_FRACTION    =    5              ;//length of fraction.
	parameter           DISPLAY_MESSAGE     =   " us"           ;//message after fraction.
	parameter      	    DISPLAY_DEPTH       =   20              ;//length of $time/$realtime.
`elsif MS
	parameter           DISPLAY_UNIT        =   -3              ;//0 second, -3 ms, -6 us, -9 ns, -12 ps, -15 fs.
	parameter    	    DISPLAY_FRACTION    =    5              ;//length of fraction.
	parameter           DISPLAY_MESSAGE     =   " ms"           ;//message after fraction.
	parameter      	    DISPLAY_DEPTH       =   20              ;//length of $time/$realtime.
`elsif NS
	parameter           DISPLAY_UNIT        =   -9              ;//0 second, -3 ms, -6 us, -9 ns, -12 ps, -15 fs.
	parameter    	    DISPLAY_FRACTION    =    5              ;//length of fraction.
	parameter           DISPLAY_MESSAGE     =   " ns"           ;//message after fraction.
	parameter      	    DISPLAY_DEPTH       =   20              ;//length of $time/$realtime.
`else
	parameter           DISPLAY_UNIT        =   -6              ;//0 second, -3 ms, -6 us, -9 ns, -12 ps, -15 fs.
	parameter    	    DISPLAY_FRACTION    =    5              ;//length of fraction.
	parameter           DISPLAY_MESSAGE     =   " us"           ;//message after fraction.
	parameter      	    DISPLAY_DEPTH       =   20              ;//length of $time/$realtime.
`endif
    //------
    /*
    initial begin
        $timeformat(DISPLAY_UNIT,DISPLAY_FRACTION,DISPLAY_MESSAGE,DISPLAY_DEPTH);//$timeformat(-6,5," us",20);
    end
    */

//--------------------------------------------------------------------------------
//------


//------end