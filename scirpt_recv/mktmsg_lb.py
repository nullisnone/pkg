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
 
def parse_input_line(line):
    tokens = line.strip().split(',')
    data = bytearray()
    for token in tokens:
        token = token.strip()
        if not token:
            continue
        if token == '|':
            data.append(255)
        else:
            try:
                val = int(token)
                if val < 0:
                    data.append(0)
                elif val >= 255:
                    data.append(254)
                else:
                    data.append(val)
            except ValueError:
                pass # Ignore non-integer tokens
    return data

def format_output_data(data):
    tokens = []
    for byte in data:
        if byte == 255:
            tokens.append('|')
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

        with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
            packet_count = 0
            for line in f_in:
                packet_data = parse_input_line(line)
                if not packet_data:
                    continue

                # Send packet
                ret = ndpp_impl.yusur_ndpp_transmit(tx_chn, packet_data, len(packet_data), 0)
                if ret < 0:
                    print(f"Failed to send packet {packet_count}")
                    break

                # Receive packet
                buf = bytearray(8192)
                start_time = time.time()
                received = False
                while time.time() - start_time < 2: # 2 second timeout per packet
                    result = ndpp_impl.yusur_ndpp_receive(rx_chn, buf, len(buf), ndpp_impl._flag_enum.NDPP_NONBLOCK)
                    if result > 0:
                        output_line = format_output_data(buf[:result])
                        f_out.write(output_line + "\n")
                        received = True
                        break
                    time.sleep(0.0001) # Short sleep to avoid busy wait
                
                if not received:
                    print(f"Timeout waiting for packet {packet_count}")
                
                packet_count += 1
                if packet_count % 100 == 0:
                    print(f"Processed {packet_count} packets...")

        print(f"Finished processing {packet_count} packets.")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        ndpp_impl.yusur_ndpp_dev_destroy(ndpp_dev)

if __name__ == "__main__":
    if len(sys.argv) > 2:
        run_test_loop(sys.argv[1], sys.argv[2])
    else:
        print("Usage: python mktmsg_lb.py <input_file> <output_file>")
