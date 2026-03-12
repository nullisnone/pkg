# -*- coding:utf-8 -*-
# @Author: Yusur
# @Date: 2024/11/13 15:22
# @File: mktmsg_lb.py
import json
import socket
import sys
import signal
import time
import re
import struct
from yusur_ndpp_impl import YusurNdppImpl

REG_OFFSET_SRC_IP   = 0x0100
REG_OFFSET_DST_IP   = 0x0104
REG_OFFSET_SRC_PORT = 0x0108
REG_OFFSET_DST_PORT = 0x010C

mkt_recv_chn = None
pcap_opt     = None
recv_data    = "chn_0.pcap"

cfg_file = 'mktmsg_lb_cfg.json'
 
def parse_matrices(file_path):
    matrices = []
    current_matrix = []
    with open(file_path, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                if current_matrix:
                    matrices.append(current_matrix)
                    current_matrix = []
                continue
            row = []
            tokens = line.split(',')
            for token in tokens:
                token = token.strip()
                if not token: continue
                try:
                    val = int(token)
                    row.append(val)
                except ValueError:
                    pass
            if row:
                current_matrix.append(row)
    if current_matrix:
        matrices.append(current_matrix)
    return matrices

def format_output_data(data):
    tokens = []
    for byte in data:
        if byte == 254:
            tokens.append('|')
        elif byte == 255:
            tokens.append('@')
        else:
            tokens.append(str(byte))
    return ",".join(tokens)

def run_test_loop(input_file, output_file):
    print(f"Running test loop with input file: {input_file}, output file: {output_file}")
    
    with open(cfg_file, 'r', encoding='UTF-8') as file:    
        cfg_info = json.load(file)
        dev_name = cfg_info["dev_name"]

    ndpp_impl = YusurNdppImpl()   
    ndpp_dev = ndpp_impl.yusur_ndpp_dev_create(dev_name)
    
    if ndpp_dev is None:
        print("Failed to initialize NDPP device.")
        return

    # Soft reset
    if ndpp_impl.yusur_ndpp_register_write32(ndpp_dev, 0x0000, 0x01) < 0:
        print(f"Failed to write to registers: {ndpp_impl.get_current_ndpp_error_msg()}")
        ndpp_impl.yusur_ndpp_dev_destroy(ndpp_dev)
        return
    
    print("yusur_ndpp_reset successful.")
    time.sleep(1)

    try:
        # Create TX and RX channels on DMA channel 0
        dma_channel = 0
        tx_chn = ndpp_impl.yusur_ndpp_tx_create(ndpp_dev, dma_channel)
        rx_chn = ndpp_impl.yusur_ndpp_rx_create(ndpp_dev, dma_channel)
        
        if tx_chn is None or rx_chn is None:
            print("Failed to create TX or RX channel")
            ndpp_impl.yusur_ndpp_dev_destroy(ndpp_dev)
            return

        # Print Input File Content
        print(f"--- Input File Content ({input_file}) ---")
        # with open(input_file, 'r') as f:
        #    print(f.read())
        print("----------------------------------------")

        matrices = parse_matrices(input_file)
        if len(matrices) != 2:
            print(f"Error: Expected 2 matrices, found {len(matrices)}")
            return

        m1 = matrices[0]
        m2 = matrices[1]
        
        rows1 = len(m1)
        cols1 = len(m1[0]) if rows1 > 0 else 0
        rows2 = len(m2)
        cols2 = len(m2[0]) if rows2 > 0 else 0
        
        if rows1 > 128 or cols1 > 128:
            print(f"ERROR: 1st matrix size ({rows1}x{cols1}) exceeds 128x128.")
            return
        if rows2 > 128 or cols2 > 128:
            print(f"ERROR: 2nd matrix size ({rows2}x{cols2}) exceeds 128x128.")
            return

        # Helper to pack 32 rows x 128 cols (4096 items) into 4096 bytes (uint8)
        # Each item is 1 byte. We pack 32 rows (4096 bytes) to fill the packet.
        def get_packed_data(matrix, start_row):
            packed = bytearray()
            # We process 32 rows per packet to cover 128 rows in 4 packets
            rows_to_pack = 32
            
            for r in range(start_row, start_row + rows_to_pack):
                row_data = matrix[r] if r < len(matrix) else []
                # Pad row to 128 items
                if len(row_data) < 128:
                    row_data.extend([0] * (128 - len(row_data)))
                
                # Pack 128 items into 128 bytes (uint8)
                for c in range(128):
                    val = row_data[c] & 0xFF
                    packed.append(val)
            
            # Pad the packet to 4096 bytes if needed
            if len(packed) < 4096:
                packed.extend([0] * (4096 - len(packed)))
                
            return packed

        # Define the 8 packets
        # Headers adjusted to cover full 128 rows (Step 32 rows per packet)
        # Matrix 1: Start 0, 32 (0x20), 64 (0x40), 96 (0x60)
        # Matrix 2: Start 0, 32 (0x20), 64 (0x40), 96 (0x60)
        headers = [
            b'\x00\x01\x00\x00\x00\x00\x00\x00', # 0x...0100 (Row 0)
            b'\x20\x01\x00\x00\x00\x00\x00\x00', # 0x...0120 (Row 32)
            b'\x40\x01\x00\x00\x00\x00\x00\x00', # 0x...0140 (Row 64)
            b'\x60\x01\x00\x00\x00\x00\x00\x00', # 0x...0160 (Row 96)
            b'\x00\x02\x00\x00\x00\x00\x00\x00', # 0x...0200 (Row 0)
            b'\x20\x02\x00\x00\x00\x00\x00\x00', # 0x...0220 (Row 32)
            b'\x40\x02\x00\x00\x00\x00\x00\x00', # 0x...0240 (Row 64)
            b'\x60\x02\x00\x00\x00\x00\x00\xff'  # 0x...0260 (Row 96) - Trigger
        ]

        packets_data = []
        
        # Packet 1-4: Matrix A (Rows 0-127, steps of 32)
        packets_data.append(get_packed_data(m1, 0))
        packets_data.append(get_packed_data(m1, 32))
        packets_data.append(get_packed_data(m1, 64))
        packets_data.append(get_packed_data(m1, 96))
        
        # Packet 5-8: Matrix B (Rows 0-127, steps of 32)
        packets_data.append(get_packed_data(m2, 0))
        packets_data.append(get_packed_data(m2, 32))
        packets_data.append(get_packed_data(m2, 64))
        packets_data.append(get_packed_data(m2, 96))

        with open(output_file, 'w') as f_out:
            # Send 8 Packets
            for i in range(8):
                pkt = bytearray()
                pkt.extend(headers[i])
                pkt.extend(packets_data[i])
                
                if len(pkt) != 4104:
                    print(f"Error: Packet {i+1} length is {len(pkt)}, expected 4104.")
                    return
                print(f"Sending batch {i+1}/8, length: {len(pkt)}...")
                #rint(pkt.hex())
                ret = ndpp_impl.yusur_ndpp_transmit(tx_chn, pkt, len(pkt), 0)
                if ret < 0:
                    err_code, err_msg = ndpp_impl.get_current_ndpp_error_msg()
                    print(f"Failed to send packet {i+1}. Error: {err_code}, {err_msg}")
                    return
                # Small delay between packets
                #time.sleep(0.01)

            # Receive packets (Expect 1 batch of 32776 bytes)
            print("Waiting for response (Expect 1 batch of 32776 bytes)...")
            
            total_batches = 1
            batch_size = 32776
            
            for batch_idx in range(total_batches):
                print(f"--- Receiving Batch {batch_idx + 1}/{total_batches} ---")
                
                batch_data = bytearray()
                
                # Loop to receive full batch
                while len(batch_data) < batch_size:
                    # Read into a temp buffer
                    temp_buf = bytearray(32776) 
                    result = ndpp_impl.yusur_ndpp_receive(rx_chn, temp_buf, len(temp_buf), 0) # 0 = Blocking? Or use loop with sleep?
                    # The original code used NONBLOCK with a loop. Let's stick to that pattern but improved.
                    # Wait, original code: ndpp_impl.yusur_ndpp_receive(..., NDPP_NONBLOCK)
                    
                    if result > 0:
                        batch_data.extend(temp_buf[:result])
                        print(f"Received {result} bytes. Total: {len(batch_data)}/{batch_size}")
                        #rint(temp_buf[:result].hex())
                    else:
                        # print("Waiting for data...")
                        time.sleep(0.001) # Small sleep to avoid CPU spin
                
                print(f"Batch {batch_idx + 1} received {len(batch_data)} bytes.")

                # Process the batch
                current_batch = batch_data[:batch_size]
                
                # 1. Header (8 bytes)
                header = current_batch[:8]
                # Convert header to hex string for display
                header_hex = "0x" + "".join(f"{b:02x}" for b in reversed(header)) # Little Endian display? Or Big?
                # Original code just printed bytes. Let's stick to bytes or make it clearer.
                # User said header is 0x0101...01.
                print(f"Header: {header.hex()}") 
                f_out.write(f"Header: {header.hex()}\n")
                
                # 2. Data (32768 bytes -> 128 rows * 128 cols * 2 bytes)
                raw_data = current_batch[8:32776]
                try:
                    # Unpack 16384 uint16 values (Little Endian)
                    # 128 * 128 = 16384
                    num_vals = len(raw_data) // 2
                    vals = struct.unpack(f'<{num_vals}H', raw_data)
                    
                    # 128 rows
                    rows_per_batch = 128
                    cols_per_row = 128
                    
                    for r in range(rows_per_batch):
                        start_idx = r * cols_per_row
                        end_idx = start_idx + cols_per_row
                        row_vals = vals[start_idx:end_idx]
                        
                        # Format as comma-separated string
                        row_str = ",".join(str(v) for v in row_vals)
                        # print(f"Row {r}: {row_str[:50]}...") # Print preview
                        f_out.write(row_str + "\n")
                        
                except Exception as e:
                    print(f"Error unpacking batch {batch_idx + 1}: {e}")
                    f_out.write(f"Error unpacking batch {batch_idx + 1}: {e}\n")
                
                f_out.write("\n") # Separator between batches

    except Exception as e:
        print(f"Error: {e}")
    finally:
        ndpp_impl.yusur_ndpp_dev_destroy(ndpp_dev)

if __name__ == "__main__":
    if len(sys.argv) > 2:
        run_test_loop(sys.argv[1], sys.argv[2])
    else:
        print("Usage: python mktmsg_lb.py <input_file> <output_file>")
