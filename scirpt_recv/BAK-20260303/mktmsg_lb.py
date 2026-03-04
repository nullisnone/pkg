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
 
class Pcap:
    def __init__(self, filename, link_type=1):
        self.pcap_file = open(filename, 'wb')
        self.pcap_file.write(struct.pack('@ I H H i I I I', 0xa1b2c3d4, 2, 4, 0, 0, 65535, link_type))
 
    def write(self, data, data_len):
        ts_sec, ts_usec = map(int, str(time.time()).split('.'))
        self.pcap_file.write(struct.pack('@ I I I I', ts_sec, ts_usec, data_len, data_len))
        return self.pcap_file.write(data)
 
    def close(self):
        self.pcap_file.close()

def run_test_loop(input_pcap_file):
    print(f"Running test loop with input file: {input_pcap_file}")
    output_pcap_file = "output.pcap"
    
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

        out_pcap = Pcap(output_pcap_file)
        
        with open(input_pcap_file, 'rb') as f:
            # Skip global header (24 bytes)
            f.read(24)
            
            packet_count = 0
            while True:
                # Read packet header (16 bytes)
                header = f.read(16)
                if not header:
                    break # End of file
                
                ts_sec, ts_usec, incl_len, orig_len = struct.unpack('@ I I I I', header)
                # Read packet data
                packet_data = f.read(incl_len)
                if not packet_data:
                    break

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
                        out_pcap.write(buf[:result], result)
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
        if 'out_pcap' in locals():
            out_pcap.close()
        ndpp_impl.yusur_ndpp_dev_destroy(ndpp_dev)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        run_test_loop(sys.argv[1])
    else:
        print("Usage: python mktmsg_lb.py <input_pcap_file>")
