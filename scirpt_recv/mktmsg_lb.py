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
        with open(input_file, 'r') as f:
            print(f.read())
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
        
        if cols1 != rows2:
            print(f"ERROR: 1st matrix COL number ({cols1}) is not identical to 2nd matrix ROW number ({rows2}). Just exit with error.")
            return

        if rows1 > 8 or cols1 > 8:
            print(f"ERROR: 1st matrix size ({rows1}x{cols1}) exceeds 8x8.")
            return
        if rows2 > 8 or cols2 > 8:
            print(f"ERROR: 2nd matrix size ({rows2}x{cols2}) exceeds 8x8.")
            return

        # Construct packet
        packet = bytearray()
        
        # Header (8 bytes)
        # 1st Matrix Info
        packet.append(1)      # ID
        packet.append(rows1)
        packet.append(cols1)
        packet.append(255)    # Break
        
        # 2nd Matrix Info
        packet.append(2)      # ID
        packet.append(rows2)
        packet.append(cols2)
        packet.append(255)    # Break
        
        # Data Padding Helper
        def append_padded_matrix(matrix, r_count, c_count):
            for r in range(8):
                if r < r_count:
                    row_data = matrix[r]
                    for c in range(8):
                        if c < c_count:
                            val = row_data[c]
                            if val > 255:
                                print(f"ERROR: Data value {val} exceeds 255.")
                                return False
                            packet.append(val)
                        else:
                            packet.append(0) # Pad column
                else:
                    packet.extend([0] * 8) # Pad row
            return True

        if not append_padded_matrix(m1, rows1, cols1): return
        if not append_padded_matrix(m2, rows2, cols2): return

        if len(packet) != 136:
            print(f"Warning: Packet length is {len(packet)}, expected 136.")

        with open(output_file, 'w') as f_out:
            # Send packet
            print(f"Sending combined matrix packet, length: {len(packet)}")
            ret = ndpp_impl.yusur_ndpp_transmit(tx_chn, packet, len(packet), 0)
            if ret < 0:
                print("Failed to send packet")
            else:
                # Receive packet
                buf = bytearray(8192)
                start_time = time.time()
                received = False
                while time.time() - start_time < 2: # 2 second timeout per packet
                    result = ndpp_impl.yusur_ndpp_receive(rx_chn, buf, len(buf), ndpp_impl._flag_enum.NDPP_NONBLOCK)
                    if result > 0:
                        print(f"Received {result} bytes")
                        data = buf[:result]
                        
                        if len(data) >= 136:
                            # 1. Print Header (8 bytes)
                            header = data[:8]
                            header_str = ",".join(str(b) for b in header)
                            print(header_str)
                            f_out.write(header_str + "\n")
                            
                            # 2. Print Empty Line
                            print()
                            f_out.write("\n")
                            
                            # 3. Print Matrix (128 bytes, 8x8 uint16)
                            matrix_bytes = data[8:136]
                            # Unpack 64 unsigned shorts (Little Endian)
                            try:
                                matrix_vals = struct.unpack('<64H', matrix_bytes)
                                for i in range(8):
                                    row_vals = matrix_vals[i*8 : (i+1)*8]
                                    row_str = ",".join(str(val) for val in row_vals)
                                    print(row_str)
                                    f_out.write(row_str + "\n")
                            except struct.error as e:
                                print(f"Error unpacking matrix: {e}")
                                raw_str = ",".join(str(b) for b in data)
                                print(raw_str)
                                f_out.write(raw_str + "\n")
                        else:
                            # Fallback for unexpected length
                            raw_str = ",".join(str(b) for b in data)
                            print(raw_str)
                            f_out.write(raw_str + "\n")

                        received = True
                        break
                    time.sleep(0.0001) # Short sleep to avoid busy wait
                
                if not received:
                    print("Timeout waiting for response")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        ndpp_impl.yusur_ndpp_dev_destroy(ndpp_dev)

if __name__ == "__main__":
    if len(sys.argv) > 2:
        run_test_loop(sys.argv[1], sys.argv[2])
    else:
        print("Usage: python mktmsg_lb.py <input_file> <output_file>")
