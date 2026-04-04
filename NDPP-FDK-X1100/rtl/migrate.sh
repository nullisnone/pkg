#!/bin/bash

# Define source and destination directories
SRC_DIR="/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100/rtl"
DEST_DIR="/root/DOWNLOAD/SWIFT/pkg-20260220/pkg/NDPP-FDK-X1100-256/rtl"

# Create the new directory
mkdir -p "$DEST_DIR"

# 1. Copy the 6 files over
echo "Copying files..."
cp "$SRC_DIR/yusur_ndpp_x1100.v" "$DEST_DIR/"
cp "$SRC_DIR/ndpp_wrapper.v" "$DEST_DIR/"
cp "$SRC_DIR/design_1_wrapper.v" "$DEST_DIR/"
cp "$SRC_DIR/design_1.v" "$DEST_DIR/"
cp "$SRC_DIR/ndpp_regfile.v" "$DEST_DIR/"
cp "$SRC_DIR/yusur_hash_allocation.v" "$DEST_DIR/"

echo "Updating ports to 256-bit for DMA RX Port 0..."

# 2. Update ndpp_wrapper.v
sed -i 's/output  wire$$63:0$$              dma_p0_rx_axis_tdata/output  wire$$255:0$$             dma_p0_rx_axis_tdata/g' "$DEST_DIR/ndpp_wrapper.v"
sed -i 's/output  wire$$7:0$$               dma_p0_rx_axis_tkeep/output  wire$$31:0$$              dma_p0_rx_axis_tkeep/g' "$DEST_DIR/ndpp_wrapper.v"

# 3. Update design_1_wrapper.v
sed -i 's/output $$63:0$$user_dma_rx_0_tdata;/output $$255:0$$user_dma_rx_0_tdata;/g' "$DEST_DIR/design_1_wrapper.v"
sed -i 's/output $$7:0$$user_dma_rx_0_tkeep;/output $$31:0$$user_dma_rx_0_tkeep;/g' "$DEST_DIR/design_1_wrapper.v"
sed -i 's/output $$7:0$$user_dma_rx_0_tstrb;/output $$31:0$$user_dma_rx_0_tstrb;/g' "$DEST_DIR/design_1_wrapper.v"
sed -i 's/wire $$63:0$$user_dma_rx_0_tdata;/wire $$255:0$$user_dma_rx_0_tdata;/g' "$DEST_DIR/design_1_wrapper.v"
sed -i 's/wire $$7:0$$user_dma_rx_0_tkeep;/wire $$31:0$$user_dma_rx_0_tkeep;/g' "$DEST_DIR/design_1_wrapper.v"
sed -i 's/wire $$7:0$$user_dma_rx_0_tstrb;/wire $$31:0$$user_dma_rx_0_tstrb;/g' "$DEST_DIR/design_1_wrapper.v"

# 4. Update design_1.v
sed -i 's/output wire $$63:0$$ user_dma_rx_0_tdata,/output wire $$255:0$$ user_dma_rx_0_tdata,/g' "$DEST_DIR/design_1.v"
sed -i 's/output wire $$7:0$$  user_dma_rx_0_tkeep,/output wire $$31:0$$  user_dma_rx_0_tkeep,/g' "$DEST_DIR/design_1.v"
sed -i 's/output wire $$7:0$$  user_dma_rx_0_tstrb,/output wire $$31:0$$  user_dma_rx_0_tstrb,/g' "$DEST_DIR/design_1.v"
sed -i 's/wire $$63:0$$ yusur_hash_allocation_0_o_axiu_user0_data_TDATA;/wire $$255:0$$ yusur_hash_allocation_0_o_axiu_user0_data_TDATA;/g' "$DEST_DIR/design_1.v"
sed -i 's/wire $$7:0$$  yusur_hash_allocation_0_o_axiu_user0_data_TKEEP;/wire $$31:0$$  yusur_hash_allocation_0_o_axiu_user0_data_TKEEP;/g' "$DEST_DIR/design_1.v"

# 5. Update yusur_hash_allocation.v
sed -i 's/output reg  $$63:0$$   o_axiu_user0_data_TDATA,/output reg  $$255:0$$  o_axiu_user0_data_TDATA,/g' "$DEST_DIR/yusur_hash_allocation.v"
sed -i 's/output reg  $$7:0$$    o_axiu_user0_data_TKEEP,/output reg  $$31:0$$   o_axiu_user0_data_TKEEP,/g' "$DEST_DIR/yusur_hash_allocation.v"

# Fix out_idx width (from 32767 depth down to 8191 depth since we output 4x 64-bit at once)
sed -i 's/reg $$14:0$$ out_idx = 0;/reg $$12:0$$ out_idx = 0;/g' "$DEST_DIR/yusur_hash_allocation.v"
sed -i 's/wire $$14:0$$ next_out_idx = out_idx + 1;/wire $$12:0$$ next_out_idx = out_idx + 1;/g' "$DEST_DIR/yusur_hash_allocation.v"

# Update TKEEP width constants and pad th0_result output to 256 bits
sed -i "s/o_axiu_user0_data_TKEEP <= 8'h00;/o_axiu_user0_data_TKEEP <= 32'h00000000;/g" "$DEST_DIR/yusur_hash_allocation.v"
sed -i "s/o_axiu_user0_data_TKEEP <= 8'hff;/o_axiu_user0_data_TKEEP <= 32'h000000ff;/g" "$DEST_DIR/yusur_hash_allocation.v"
sed -i "s/o_axiu_user0_data_TDATA <= th0_result;/o_axiu_user0_data_TDATA <= {192'd0, th0_result};/g" "$DEST_DIR/yusur_hash_allocation.v"

# Replace output assignment logic block to write 256-bits at once
cat << 'EOF' > patch_hash.sed
/if (out_idx == 15'h7fff) begin/,/endcase/c\
                        if (out_idx == 13'h1fff) begin // 8191\
                            out_state <= OUT_STATE_IDLE;\
                            o_axiu_user0_data_TVALID <= 1'b0;\
                            o_axiu_user0_data_TKEEP <= 32'h00000000;\
                            o_axiu_user0_data_TLAST <= 1'b0;\
                        end else begin\
                            out_state <= OUT_STATE_OUTPUT;\
                            out_idx <= next_out_idx;\
                            o_axiu_user0_data_TVALID <= 1'b1;\
                            o_axiu_user0_data_TKEEP <= 32'hffffffff;\
                            o_axiu_user0_data_TLAST <= (next_out_idx == 13'h1fff) ? 1'b1 : 1'b0;\
                            o_axiu_user0_data_TDATA <= {mem_C_3[next_out_idx], mem_C_2[next_out_idx], mem_C_1[next_out_idx], mem_C_0[next_out_idx]};\
                        end
EOF
sed -i -f patch_hash.sed "$DEST_DIR/yusur_hash_allocation.v"
rm patch_hash.sed

echo "Migration to 256-bit DMA completed successfully."
