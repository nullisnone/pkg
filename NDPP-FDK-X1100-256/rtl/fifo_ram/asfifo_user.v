/*
 * Copyright (c) 2012, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
 * All rights reserved.
 *
 * Based on vga_fifo_dc.v in Richard Herveille's VGA/LCD core
 * Copyright (C) 2001 Richard Herveille <richard@asics.ws>
 *
 * Redistribution and use in source and non-source forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in non-source form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 * THIS WORK IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * WORK, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
`timescale 1ns / 1ps

module asfifo_user #(
    parameter ADDR_WIDTH = 4,
    //parameter DATA_WIDTH = 16,
    parameter PROG_EMPTY_OFST = 4 ,  // should >=6 at least for safe
    parameter PROG_FULL_OFST  = 12   // should <=FIFO_DEPTH-6 at least for safe
)
(
    input                       rstn,
    
    input                       wr_clk_i,
    input                       wr_en_i,
    output [ADDR_WIDTH:0]       wr_cnt ,
    output reg                  full_o ,
    output reg                  prog_full_o ,
    
    input                       rd_clk_i,
    input                       rd_en_i,
    output [ADDR_WIDTH:0]       rd_cnt ,
    output reg                  empty_o,
    output reg                  prog_empty_o,
    
    // external ram port
    output                      val_wr ,
    output [ADDR_WIDTH-1:0]     wraddr ,
    output                      val_rd ,
    output [ADDR_WIDTH-1:0]     rdaddr 
);

reg     [ADDR_WIDTH:0]          wr_addr;
reg     [ADDR_WIDTH:0]          wr_addr_gray;
reg     [ADDR_WIDTH:0]          wr_addr_gray_rd;
reg     [ADDR_WIDTH:0]          wr_addr_gray_rd_r;
wire    [ADDR_WIDTH:0]          wr_addr_rd;
wire    [ADDR_WIDTH:0]          wr_addr_nxt;
wire    [ADDR_WIDTH:0]          wr_addr_nxtnxt;
reg     [ADDR_WIDTH:0]          rd_addr;
reg     [ADDR_WIDTH:0]          rd_addr_gray;
reg     [ADDR_WIDTH:0]          rd_addr_gray_wr;
reg     [ADDR_WIDTH:0]          rd_addr_gray_wr_r;
wire    [ADDR_WIDTH:0]          rd_addr_wr;
wire    [ADDR_WIDTH:0]          rd_addr_nxt;

//--------------------------------------------------------
// Function: Binary to Gray Conversion
//--------------------------------------------------------
function [ADDR_WIDTH:0] bin_to_gray_conv;
input [ADDR_WIDTH:0] in;
begin
    bin_to_gray_conv = {in[ADDR_WIDTH], in[ADDR_WIDTH-1:0] ^ in[ADDR_WIDTH:1]};
end
endfunction

//--------------------------------------------------------
// Function: Binary to Gray Conversion
//--------------------------------------------------------
function [ADDR_WIDTH:0] gray_to_bin_conv;
input [ADDR_WIDTH:0] gray;
integer i;
begin
    gray_to_bin_conv[ADDR_WIDTH] = gray[ADDR_WIDTH];
    for (i=ADDR_WIDTH-1; i>=0; i=i-1)
    begin
        gray_to_bin_conv[i] = gray_to_bin_conv[i+1] ^ gray[i];
    end
end
endfunction


//--------------------------------------------------------
// fifo write
//--------------------------------------------------------
always @(posedge wr_clk_i or negedge rstn) begin
    if (!rstn) begin
        wr_addr <= 0;
        wr_addr_gray <= 0;
    end else if (val_wr) begin //(wr_en_i)
        wr_addr <= wr_addr + 1'b1;
        wr_addr_gray <= bin_to_gray_conv(wr_addr + 1'b1);
    end
end

// synchronize read address to write clock domain
always @(posedge wr_clk_i) begin
    rd_addr_gray_wr   <= rd_addr_gray;
    rd_addr_gray_wr_r <= rd_addr_gray_wr;
end

assign rd_addr_wr = gray_to_bin_conv(rd_addr_gray_wr_r);
assign wr_cnt = (wr_addr>=rd_addr_wr) ? wr_addr - rd_addr_wr : {1'b1, wr_addr[ADDR_WIDTH-1:0]} - {1'b0, rd_addr_wr[ADDR_WIDTH-1:0]};
assign wr_addr_nxt = wr_addr + 1'b1;
assign wr_addr_nxtnxt = wr_addr + 2'd2;

always @(posedge wr_clk_i or negedge rstn)
    if (!rstn)
        full_o <= 0;
    else if (val_wr) //(wr_en_i)
        full_o <= (wr_addr_nxtnxt[ADDR_WIDTH]!=rd_addr_wr[ADDR_WIDTH]) & (wr_addr_nxtnxt[ADDR_WIDTH-1:0]==rd_addr_wr[ADDR_WIDTH-1:0]);
    else
        full_o <= full_o & (wr_addr_nxt[ADDR_WIDTH]!=rd_addr_wr[ADDR_WIDTH]) & (wr_addr_nxt[ADDR_WIDTH-1:0]==rd_addr_wr[ADDR_WIDTH-1:0]);

always @(posedge wr_clk_i or negedge rstn)
    if (!rstn)
        prog_full_o <= 1'b0;
    else if (wr_cnt>=PROG_FULL_OFST)
        prog_full_o <= 1'b1;
    else
        prog_full_o <= 1'b0;
        
//--------------------------------------------------------
// fifo read
//--------------------------------------------------------
always @(posedge rd_clk_i or negedge rstn) begin
    if (!rstn) begin
        rd_addr <= 0;
        rd_addr_gray <= 0;
    end else if (val_rd) begin //(rd_en_i)
        rd_addr <= rd_addr + 1'b1;
        rd_addr_gray <= bin_to_gray_conv(rd_addr + 1'b1);
    end
end

// synchronize write address to read clock domain
always @(posedge rd_clk_i) begin
    wr_addr_gray_rd <= wr_addr_gray;
    wr_addr_gray_rd_r <= wr_addr_gray_rd;
end

assign wr_addr_rd = gray_to_bin_conv(wr_addr_gray_rd_r);
assign rd_cnt = (wr_addr_rd>=rd_addr) ? wr_addr_rd - rd_addr : {1'b1, wr_addr_rd[ADDR_WIDTH-1:0]} - {1'b0, rd_addr[ADDR_WIDTH-1:0]};
assign rd_addr_nxt = rd_addr + 1;

always @(posedge rd_clk_i or negedge rstn)
    if (!rstn)
        empty_o <= 1'b1;
    else if (val_rd) //(rd_en_i)
        empty_o <= (rd_addr_nxt == wr_addr_rd);
    else
        empty_o <= empty_o & (rd_addr == wr_addr_rd);

always @(posedge wr_clk_i or negedge rstn)
    if (!rstn)
        prog_empty_o <= 1'b1;
    else if (rd_cnt<=PROG_EMPTY_OFST)
        prog_empty_o <= 1'b1;
    else
        prog_empty_o <= 1'b0;


// generate dual clocked memory
assign val_rd = (!empty_o && rd_en_i);
assign val_wr = (!full_o && wr_en_i ) ;
assign wraddr = wr_addr[ADDR_WIDTH-1:0];
assign rdaddr = rd_addr[ADDR_WIDTH-1:0];

//reg [DATA_WIDTH-1:0] mem[(1<<ADDR_WIDTH)-1:0];
//
//always @(posedge rd_clk_i)
//    if (val_rd) //(rd_en_i)
//        rd_data_o <= mem[rd_addr];
//
//always @(posedge wr_clk_i)
//    if (val_wr) //(wr_en_i)
//        mem[wr_addr] <= wr_data_i;


endmodule
