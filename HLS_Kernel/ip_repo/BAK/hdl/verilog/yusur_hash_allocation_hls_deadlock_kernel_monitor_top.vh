
wire kernel_monitor_reset;
wire kernel_monitor_clock;
wire kernel_monitor_report;
assign kernel_monitor_reset = ~ap_rst_n;
assign kernel_monitor_clock = ap_clk;
assign kernel_monitor_report = 1'b0;
wire [2:0] axis_block_sigs;
wire [6:0] inst_idle_sigs;
wire [2:0] inst_block_sigs;
wire kernel_block;

assign axis_block_sigs[0] = ~Block_entry19_proc3_U0.i_axiu_key_TDATA_blk_n;
assign axis_block_sigs[1] = ~Block_entry19_proc3_U0.grp_Block_entry19_proc3_Pipeline_VITIS_LOOP_127_3_fu_2308.i_axiu_user0_data_TDATA_blk_n;
assign axis_block_sigs[2] = ~Loop_LOOP_FORWARD_proc_U0.o_axiu_user0_data_TDATA_blk_n;

assign inst_idle_sigs[0] = Block_entry19_proc3_U0.ap_idle;
assign inst_block_sigs[0] = (Block_entry19_proc3_U0.ap_done & ~Block_entry19_proc3_U0.ap_continue);
assign inst_idle_sigs[1] = Loop_LOOP_PACK_OUTPUT_proc_U0.ap_idle;
assign inst_block_sigs[1] = (Loop_LOOP_PACK_OUTPUT_proc_U0.ap_done & ~Loop_LOOP_PACK_OUTPUT_proc_U0.ap_continue);
assign inst_idle_sigs[2] = Loop_LOOP_FORWARD_proc_U0.ap_idle;
assign inst_block_sigs[2] = (Loop_LOOP_FORWARD_proc_U0.ap_done & ~Loop_LOOP_FORWARD_proc_U0.ap_continue);

assign inst_idle_sigs[3] = 1'b0;
assign inst_idle_sigs[4] = Block_entry19_proc3_U0.ap_idle;
assign inst_idle_sigs[5] = Block_entry19_proc3_U0.grp_Block_entry19_proc3_Pipeline_VITIS_LOOP_127_3_fu_2308.ap_idle;
assign inst_idle_sigs[6] = Loop_LOOP_FORWARD_proc_U0.ap_idle;

yusur_hash_allocation_hls_deadlock_idx0_monitor yusur_hash_allocation_hls_deadlock_idx0_monitor_U (
    .clock(kernel_monitor_clock),
    .reset(kernel_monitor_reset),
    .axis_block_sigs(axis_block_sigs),
    .inst_idle_sigs(inst_idle_sigs),
    .inst_block_sigs(inst_block_sigs),
    .block(kernel_block)
);


always @ (kernel_block or kernel_monitor_reset) begin
    if (kernel_block == 1'b1 && kernel_monitor_reset == 1'b0) begin
        find_kernel_block = 1'b1;
    end
    else begin
        find_kernel_block = 1'b0;
    end
end
