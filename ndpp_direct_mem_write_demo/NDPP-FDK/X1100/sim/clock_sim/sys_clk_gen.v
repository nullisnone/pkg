//--------------------------------------------------------------------------------
//  __   ___   _ ____  _   _ ____       Project     : ndpp_sim
//  \ \ / / | | / ___|| | | |  _ \      File        : sys_clk_gen.sv
//   \ V /| | | \___ \| | | | |_) |     Version     : 0.0.1
//    | | | |_| |___) | |_| |  _ <      Author      : 
//    |_|  \___/|____/ \___/|_| \_\     Date        : 2024-01-01
//                                      Description : system clock generator
//--------------------------------------------------------------------------------
//------Verilog_Header(`define)
//`include "<path_to_vh>/NDPP_SIM.vh"
//`include "<path_to_vh>/NDPP.vh"
//`include "<path_to_vh>/USER.vh"
//------Define
`define GLOBAL_PARAM
//`define LOCAL_PARAM
//--------------------------------------------------------------------------------
`timescale 1ps/1ps

module sys_clk_gen #(
	parameter        OFFSET 				= 0					,//used for keep the sys_clk_reg = 0 at the beginning.
	parameter        PERIOD 				= 10000				 //10.0ns = 10_000ps @ 100MHz

	)(
	output wire				sys_clk								,
	output wire				sys_clk_locked						,
	output wire				sys_rst_n						
	);
//--------------------------------------------------------------------------------
	//------parameters
	//parameter        	OFFSET 				= 0					;//used for keep the sys_clk_reg = 0 at the beginning.
	//parameter        	PERIOD 				= 10000				;//10.0ns = 10_000ps @ 100MHz
	localparam		 	LOCAL_OFFSET		= 0					;//used for keep the sys_clk_reg = 0 at the beginning.
	localparam		 	LOCAL_PERIOD		= 10000				;//10.0ns = 10_000ps @ 100MHz
	/*
    //------parameter
	parameter           CLOCK_OFFSET        = 0					;//used for keep the sys_clk_reg = 0 at the beginning.
	parameter           PERIOD 		        = 10_000			;//10.0ns = 10_000ps @ 100MHz
    parameter           HALFCYCLE 		    = PERIOD/2			;//05.0ns = 05_000ps @ 100MHz
    localparam		    HEARTBEAT_LENGTH    = 1_000_000         ;

    localparam          DELAY_TO_STOP       = 32'd1_000_000     ;//1us
    localparam          DELAY_TO_FINISH     = 32'd5_000_000     ;//5us

    parameter           TCQ                 = 0                 ;//Time-Clock-to-Qualifier : Used for Asynchronous-Clock-Domain, common value range is 0 ~ PERIOD. //[0:PERIOD]
    parameter           SKEW                = TCQ               ;//NC
    parameter           JITTER              = 0                 ;//NC   Recommended with $random(seed).
	*/
	//------
	reg  [00:00]			sys_clk_reg							;
	reg  [00:00]			sys_clk_locked_reg					;
	reg  [00:00]			sys_rst_n_reg						;

	reg	 [02:00]			rstn_seq							;
//--------------------------------------------------------------------------------
`ifdef GLOBAL_PARAM
	initial begin
	sys_clk_reg		= 0											;
	#(OFFSET)													;
	
	forever #(PERIOD/2) 	  sys_clk_reg = ~sys_clk_reg		;
	
	end

`elsif LOCAL_PARAM
	initial begin
	sys_clk_reg		= 0											;
	#(LOCAL_OFFSET)												;
	
	forever #(LOCAL_PERIOD/2) sys_clk_reg = ~sys_clk_reg		;
	
	end

`else
	initial begin
	sys_clk_reg		= 0											;
	end
	always begin
		#(PERIOD/2) sys_clk_reg = ~sys_clk_reg					;
	//	sys_clk_reg = #(PERIOD/2) ~sys_clk_reg					;
	end

	//always #(PERIOD/2) sys_clk_reg = ~sys_clk_reg				;

`endif
//--------------------------------------------------------------------------------
	initial begin
	rstn_seq		=	3'b101									;
	end
	
	initial begin
	sys_rst_n_reg	=	rstn_seq[2]								;
	#(100*LOCAL_PERIOD + OFFSET)								;
	sys_rst_n_reg	=	rstn_seq[1]								;
	#(100*LOCAL_PERIOD + OFFSET)								;
	sys_rst_n_reg	=	rstn_seq[0]								;
	end

	initial begin
	sys_clk_locked_reg	=	1'b0								;
	@(posedge sys_rst_n_reg) #(50*LOCAL_PERIOD) sys_clk_locked_reg = 1'b1	;
	end
	
//--------------------------------------------------------------------------------
	//------
	assign sys_clk 			= sys_clk_reg						;
	assign sys_rst_n 		= sys_rst_n_reg						;
	assign sys_clk_locked 	= sys_clk_locked_reg				;

endmodule
