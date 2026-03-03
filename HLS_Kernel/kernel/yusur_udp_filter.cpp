#include "ap_axi_sdata.h"
#include "ap_int.h"
#include "hls_stream.h"
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <iomanip>

    
#define BUFF_SIZE   10

ap_uint<32> ETH_IP_TYPE_ETH_UDP = 0x450008; // MAC_TYPE: 0x0800=IP; IP_Ver 0x4; IP_Head_Len= 5*4=20byte
ap_uint<8> UDP_TYPE_ETH_UDP = 0x11; //IP_Protocol: 0x11=UDP

void yusur_udp_filter(hls::stream<ap_uint<128> >& i_axiu_udp_param,             //五元组
                      hls::stream<ap_axiu<64, 0, 0, 0> >& i_axiu_stream_data,   //UDP data
                      hls::stream<ap_uint<80> >& o_axiu_key,                    //hash key 
                      hls::stream<ap_axiu<64, 0, 0, 0> >& o_axiu_stream_data)   //udp data after filter
{

#pragma HLS INTERFACE axis port = i_axiu_udp_param
#pragma HLS INTERFACE axis port = i_axiu_stream_data
#pragma HLS INTERFACE axis port = o_axiu_key
#pragma HLS INTERFACE axis port = o_axiu_stream_data
#pragma HLS INTERFACE ap_ctrl_none port = return


    ap_uint<64*BUFF_SIZE> batch_data = 0;    //10 * 64bit
    ap_uint<9*BUFF_SIZE> mark_data = 0;      //10 * (8+1)
    ap_axiu<64, 0, 0, 0> i_row_data;
    uint8_t element_cnt = 0;
    bool init_done = false;
    bool match_flag = false;
    bool frame_flag = false;
    bool src_ip_match = false;
    bool dst_ip_match = false;
    bool src_port_match = false;
    bool dst_port_match = false;
    ap_axiu<64, 0, 0, 0> curr_udp;
    ap_uint<80> key = 0;
    ap_uint<32> SOURCE_IP = 0;
    ap_uint<32> DESTINATION_IP = 0;
    ap_uint<16> SOURCE_PORT = 0;
    ap_uint<16> DESTINATION_PORT = 0;
 
    ap_uint<128> udp_param = i_axiu_udp_param.read(); 
    SOURCE_IP(8*1-1, 8*0) = udp_param(8*4-1, 8*3);
    SOURCE_IP(8*2-1, 8*1) = udp_param(8*3-1, 8*2);
    SOURCE_IP(8*3-1, 8*2) = udp_param(8*2-1, 8*1);
    SOURCE_IP(8*4-1, 8*3) = udp_param(8*1-1, 8*0);
    DESTINATION_IP(8*1-1, 8*0) = udp_param(32+8*4-1, 32+8*3);
    DESTINATION_IP(8*2-1, 8*1) = udp_param(32+8*3-1, 32+8*2);
    DESTINATION_IP(8*3-1, 8*2) = udp_param(32+8*2-1, 32+8*1);
    DESTINATION_IP(8*4-1, 8*3) = udp_param(32+8*1-1, 32+8*0);
    SOURCE_PORT(8*1-1, 8*0) = udp_param(64+8*2-1, 64+8*1);
    SOURCE_PORT(8*2-1, 8*1) = udp_param(64+8*1-1, 64+8*0); 
    DESTINATION_PORT(8*1-1, 8*0) = udp_param(96+8*2-1, 96+8*1);
    DESTINATION_PORT(8*2-1, 8*1) = udp_param(96+8*1-1, 96+8*0); 
 
    LOOP_WORKING:
    while(1)
    {
#pragma HLS PIPELINE II = 1
        if((i_axiu_stream_data.empty() == 0) && (element_cnt <= 9)) //FIFO not empty, and buff not full 
        {
            i_row_data = i_axiu_stream_data.read();
            ap_uint<64> i_data = i_row_data.data;
            ap_uint<9> i_mark = (i_row_data.last, i_row_data.keep); //save "keep" and "last" to cache
            switch(element_cnt)
            {
                case 0 : 
                    batch_data(64*(element_cnt+1)-1, 64*element_cnt) = i_data; 
                    mark_data(9*(element_cnt+1)-1, 9*element_cnt) = i_mark;
                break;
                case 1 : 
                    batch_data(64*(1+1)-1, 64*1) = i_data; 
                    mark_data(9*(1+1)-1, 9*1) = i_mark;
                break;
                case 2 : 
                    batch_data(64*(2+1)-1, 64*2) = i_data; 
                    mark_data(9*(2+1)-1, 9*2) = i_mark;
                break;
                case 3 : 
                    batch_data(64*(3+1)-1, 64*3) = i_data; 
                    mark_data(9*(3+1)-1, 9*3) = i_mark;
                break;
                case 4 : 
                    batch_data(64*(4+1)-1, 64*4) = i_data; 
                    mark_data(9*(4+1)-1, 9*4) = i_mark;
                break;
                case 5 : 
                    batch_data(64*(5+1)-1, 64*5) = i_data; 
                    mark_data(9*(5+1)-1, 9*5) = i_mark;
                break;
                case 6 : 
                    batch_data(64*(6+1)-1, 64*6) = i_data; 
                    mark_data(9*(6+1)-1, 9*6) = i_mark;
                break;
                case 7 : 
                    batch_data(64*(7+1)-1, 64*7) = i_data; 
                    mark_data(9*(7+1)-1, 9*7) = i_mark;
                break;
                case 8 : 
                    batch_data(64*(8+1)-1, 64*8) = i_data; 
                    mark_data(9*(8+1)-1, 9*8) = i_mark;
                break;
                case 9 : 
                    batch_data(64*(9+1)-1, 64*9) = i_data; 
                    mark_data(9*(9+1)-1, 9*9) = i_mark;
                break;
                default : 
                break;
            }
            element_cnt++;
        }
        if(element_cnt >= 8 && frame_flag == false) //when up to 5 data, then start work
        {
            frame_flag = true;  //working
            ap_uint<24> get_eth_ip_type = batch_data(119, 96);
            ap_uint<8> get_udp_type = batch_data(191, 184);
            ap_uint<32> get_src_ip = batch_data(239, 208);
            ap_uint<32> get_dst_ip = batch_data(271, 240);
            ap_uint<16> get_src_port = batch_data(287, 272);
            ap_uint<16> get_dst_port = batch_data(303, 288);

            if((get_src_ip == SOURCE_IP) || (SOURCE_IP == 0))
            {
                src_ip_match = true;
            }
            else 
            {
                src_ip_match = false;
            }

            if((get_dst_ip == DESTINATION_IP) || (DESTINATION_IP == 0))
            {
                dst_ip_match = true;
            }
            else 
            {
                dst_ip_match = false;
            }

            if((get_src_port == SOURCE_PORT) || (SOURCE_PORT == 0))
            {
                src_port_match = true;
            }
            else 
            {
                src_port_match = false;
            }

            if((get_dst_port == DESTINATION_PORT) || (DESTINATION_PORT == 0))
            {
                dst_port_match = true;
            }
            else 
            {
                dst_port_match = false;
            } 

            if((get_eth_ip_type == ETH_IP_TYPE_ETH_UDP) && (get_udp_type == UDP_TYPE_ETH_UDP) && //type == IP; protocpl == UDP
               (src_ip_match == true) && (dst_ip_match == true) && (src_port_match == true) && (dst_port_match == true))     //ip and port match
            {
                match_flag = true;
                key(8*0+7, 8*0) = batch_data(448+7, 448);
                key(8*1+7, 8*1) = batch_data(440+7, 440);
                key(8*2+7, 8*2) = batch_data(432+7, 432);
                key(8*3+7, 8*3) = batch_data(424+7, 424);
                key(8*4+7, 8*4) = batch_data(416+7, 416);
                key(8*5+7, 8*5) = batch_data(408+7, 408);
                key(8*6+7, 8*6) = batch_data(400+7, 400);
                key(8*7+7, 8*7) = batch_data(392+7, 392);
                key(8*8+7, 8*8) = batch_data(384+7, 384); 
                key(8*9+7, 8*9) = batch_data(376+7, 376); //message_type
                o_axiu_key.write(key);
            }
            else 
            {
                match_flag = false;
            }
        }
        if(frame_flag == true && element_cnt > 0)
        {
            curr_udp.data = batch_data(63, 0);
            curr_udp.keep = mark_data(7, 0);
            curr_udp.last = mark_data(8, 8);
            batch_data >>= 64;
            mark_data >>= 9;
            element_cnt--;
            if(match_flag == true)
            {
                o_axiu_stream_data.write(curr_udp);
            }
            if(curr_udp.last == true) //recive last then start, end the current frame 
            {
                frame_flag = false;
                match_flag = false;
            }
        } 
    }  
}