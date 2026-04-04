`timescale 1 ps / 1 ps

module  get_fpga_ver(
    i_clk       ,
    i_rstn      ,
    o_fpga_ver
);

input           i_clk       ;
input           i_rstn      ;
output  [31:0]  o_fpga_ver  ;
// ---------------------------- main logic ---------------------------- //
wire          t_cfgclk      ;
wire  [31:0]  t_fpga_version;
wire          t_datavalid   ;
reg   [31:0]  r0_fpga_version,r1_fpga_version,r2_fpga_version;

USR_ACCESSE2 USR_ACCESSE2_inst (
  .CFGCLK         (t_cfgclk       ), // unused    
  .DATA           (t_fpga_version ),         
  .DATAVALID      (t_datavalid    )  // unused
);

always @(posedge i_clk) begin
  if(~i_rstn) begin
    r0_fpga_version <=  32'h0;
    r1_fpga_version <=  32'h0;
    r2_fpga_version <=  32'h0;  
  end else begin
    r0_fpga_version <=  t_fpga_version  ;
    r1_fpga_version <=  r0_fpga_version ;
    r2_fpga_version <=  r1_fpga_version ;  
  end
end

assign  o_fpga_ver = r2_fpga_version;

endmodule

