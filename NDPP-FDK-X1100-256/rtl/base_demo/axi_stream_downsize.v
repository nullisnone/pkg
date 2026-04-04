`timescale 1ps/1ps
module axi_stream_downsize #(
  parameter integer DW    = 96,
  parameter integer RATIO = 3, // Should always be RATIO:1 (downsizer)
  parameter integer USR_W = 2
)
(
  // System Signals
  input  wire                  aclk,
  input  wire                  aresetn,
  // Slave side
  input  wire                  s_axis_tvalid,
  output wire                  s_axis_tready,
  input  wire [DW-1:0]         s_axis_tdata,
  input  wire [DW/8-1:0]       s_axis_tkeep,
  input  wire [USR_W-1:0]      s_axis_tuser,
  input  wire                  s_axis_tlast,
  
  // Master side
  output wire                  m_axis_tvalid,
  input  wire                  m_axis_tready,
  output wire [DW/RATIO-1:0]   m_axis_tdata,
  output wire [DW/RATIO/8-1:0] m_axis_tkeep,
  output wire [USR_W-1:0]      m_axis_tuser,
  output wire                  m_axis_tlast
);

  wire                     in_last;
//   wire                     in_first;
  wire                     out_last;
//   wire                     out_first;
  wire[RATIO-1:0]          next_val;
  reg [RATIO-1:0]          down_val_r;
  reg [DW/RATIO-1:0]       cur_data;
  reg [DW/RATIO/8-1:0]     cur_keep;
  reg [DW/RATIO/8-1:0]     nxt_keep;
  //          _   _   _   _   _   _   _   _   _   _   _   _   _
  // Clock   | |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| 
  //         ________ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___
  // up_val  ________X___X___X___X___X___X___X___X___X___X___X___
  //            001   010 100 001 010 100 001 010 100 001 010 100      
  //              _____________________________________________
  // s_valid ____|
  //              ___          ___        ___          ___
  // s_ready ____|   |________|   |______|   |________|   |______
  //         ____ ___________ ___________ ___________ ___________
  // s_data  ____X___________X___________X___________X___________
  //          xxx     ABC         DEF         GHI        JKL
  //              ______________________________________________
  // m_valid ____|
  //         ____ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___ ___
  // m_data  ____X___X___X___X___X___X___X___X___X___X___X___X___
  //           x   C   B   A   F   E   D   I   H   G   L   K   J

  assign in_last    = s_axis_tlast;
//   assign in_first   = s_axis_tuser[1];
  assign out_last   = in_last  & nxt_keep == 0;
//   assign out_first  = in_first & down_val_r[0];
  assign next_val   = out_last ? {{RATIO{1'b0}},1'b1} : {down_val_r[RATIO-2:0],down_val_r[RATIO-1]};
  always @ (posedge aclk or negedge aresetn)
  begin
    if (~aresetn)
      down_val_r    <= {{RATIO{1'b0}},1'b1};
    else if (m_axis_tvalid & m_axis_tready)
      down_val_r    <= next_val;
  end

  always @ (*)
  begin : data_gen
    integer i;
    cur_data = 0;
    cur_keep = 0;
    nxt_keep = 0;
    for (i=0;i<RATIO;i=i+1)
    begin : loop
      if (down_val_r[i])
      begin
        cur_data = s_axis_tdata[DW/RATIO*i+:DW/RATIO];
        cur_keep = s_axis_tkeep[DW/RATIO/8*i+:DW/RATIO/8];
        if (i != RATIO-1)
        nxt_keep = s_axis_tkeep[DW/RATIO/8*(i+1)+:DW/RATIO/8];
      end
    end
  end

  assign m_axis_tdata   = cur_data;
  assign m_axis_tkeep   = cur_keep;
  assign m_axis_tvalid  = s_axis_tvalid;
  assign s_axis_tready  = m_axis_tready & (down_val_r[RATIO-1] | out_last);
  assign m_axis_tlast   = out_last;
  assign m_axis_tuser   = s_axis_tuser;

endmodule
