`default_nettype none
module axi_stream_upsize #(
  parameter integer DW          =   64,
  parameter integer RATIO       =   4,      // Should always be 1:C_RATIO (upsizer)
  parameter integer USER_WIDTH  =   1       // The tuser remains unchanged during transmission (except for the last beat)
)
(
  // System Signals
  input  wire                     sys_clk,
  input  wire                     sys_rstn,
  // Slave side
  input  wire                     s_axis_tvalid,
  output wire                     s_axis_tready,
  input  wire [DW-1:0]            s_axis_tdata,
  input  wire [DW/8-1:0]          s_axis_tkeep,
  input  wire                     s_axis_tlast,
  input  wire [USER_WIDTH-1 :0]   s_axis_tuser, // Only For MAC CRC ERROR SIGNAL
  
  // Master side
  output wire                     m_axis_tvalid,
  input  wire                     m_axis_tready,
  output wire [DW*RATIO-1:0]      m_axis_tdata,
  output wire [DW*RATIO/8-1:0]    m_axis_tkeep,
  output wire                     m_axis_tlast,
  output wire [USER_WIDTH-1 :0]   m_axis_tuser
);

  wire                      last_word;
  reg [RATIO-1:0]           up_val_r;
  reg [DW*(RATIO-1)-1:0]    up_data_r;
  reg [DW/8*(RATIO-1)-1:0]  up_keep_r;
  wire[RATIO-1:0]           next_val;
  reg [DW*RATIO-1:0]        next_data;
  reg [DW/8*RATIO-1:0]      next_keep;

  assign last_word  = s_axis_tlast;
  assign next_val   = last_word ? {{RATIO{1'b0}},1'b1} : {up_val_r[RATIO-2:0],up_val_r[RATIO-1]};
  
  always @ (*)
  begin : data_gen
    integer i;
    reg [DW*16-1:0] data_mask0;
    reg [DW*16-1:0] data_mask1;
    reg [DW/8*16-1:0] keep_mask0;
    reg [DW/8*16-1:0] keep_mask1;
    next_data = up_data_r;
    next_keep = up_keep_r;
    for (i=0;i<RATIO;i=i+1)
    begin : loop
      if (up_val_r[i])
      begin
        data_mask0 = {{(15*DW){1'b0}},{DW{1'b1}}} << (i*DW);
        data_mask1 = {(16*DW){1'b1}} << (i*DW);
        keep_mask0 = {{(15*DW/8){1'b0}},{DW/8{1'b1}}} << (i*DW/8);
        keep_mask1 = {16*DW/8{1'b1}} << (i*DW/8);
        next_data  = (up_data_r & ~data_mask1[DW*RATIO-1:0])   | ({RATIO{s_axis_tdata}} & data_mask0[DW*RATIO-1:0]);
        next_keep  = (up_keep_r & ~keep_mask1[DW/8*RATIO-1:0]) | ({RATIO{s_axis_tkeep}} & keep_mask0[DW/8*RATIO-1:0]);
      end
    end
  end
  
  always @ (posedge sys_clk or negedge sys_rstn)
  begin
    if (~sys_rstn)
    begin
      up_val_r    <= {{RATIO{1'b0}},1'b1};
      up_data_r   <= {DW*(RATIO-1){1'b0}};
      up_keep_r   <= {(DW/8)*(RATIO-1){1'b0}};
    end
    else if (s_axis_tvalid & s_axis_tready)
    begin
      up_val_r    <= next_val;
      up_data_r   <= next_data;
      up_keep_r   <= next_keep;
    end
  end

  assign m_axis_tdata   = next_data;
  assign m_axis_tkeep   = next_keep;
  assign m_axis_tvalid  =  (up_val_r[RATIO-1] | last_word) & s_axis_tvalid;
  assign s_axis_tready  = ~(up_val_r[RATIO-1] | last_word) | m_axis_tready;

  assign m_axis_tuser   = s_axis_tuser;
  assign m_axis_tlast   = last_word;
endmodule
`default_nettype wire
