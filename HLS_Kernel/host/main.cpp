
// #include "utils.h"
#include <fstream>
#include <string>
#include <vector>
#include <stdio.h> 
#include <stdint.h>
#include <iostream>
#include "ap_int.h"
#include "hls_stream.h" 
#include "./../kernel/kernel.h"
// #include "kernel.h"
#include <cstdlib>

size_t readHexFromFile(const std::string& filename, std::vector<uint64_t>& dataArray) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        std::cerr << "Error: Unable to open file " << filename << std::endl;
        return 0;
    }

    std::string line;
    while (std::getline(file, line)) {
        std::stringstream ss;
        ss << std::hex << line;  // 设置流为16进制格式

        uint64_t value;
        ss >> value;             // 将16进制字符串转换为数值
        dataArray.push_back(value);
    }

    file.close();
    return dataArray.size();
}
int main() {
    
    hls::stream<ap_axiu<64, 0, 0, 0>, 1024>i_axiu_stream_data;
    ap_axiu<64, 0, 0, 0> udp_data;
    hls::stream<ap_uint<128>, 8> i_axiu_udp_param;
    hls::stream<ap_uint<80>, 1024> o_axiu_key;                   //hash key 
    hls::stream<ap_axiu<64, 0, 0, 0>, 1024> o_axiu_stream_data;

    ap_uint<32> SOURCE_IP;
    ap_uint<32> DESTINATION_IP;
    ap_uint<32> SOURCE_PORT = 1000;
    // ap_uint<32> DESTINATION_PORT = 30000;
    ap_uint<32> DESTINATION_PORT = 0;

    SOURCE_IP(31, 24) = 39;
    SOURCE_IP(23, 16) = 16;
    SOURCE_IP(15,  8) = 19;
    SOURCE_IP( 7,  0) = 10;

    DESTINATION_IP(31, 24) = 239;
    DESTINATION_IP(23, 16) = 16;
    DESTINATION_IP(15,  8) = 19;
    DESTINATION_IP( 7,  0) = 30; 

    i_axiu_udp_param.write((DESTINATION_PORT, SOURCE_PORT, DESTINATION_IP, SOURCE_IP));
    
    
    std::vector<uint64_t> dataArray;
    size_t count = readHexFromFile("/home/lizy/Prj/udp_equalizer/HLS_PRJ/HLS_Kernel/host/src.txt", dataArray);

    std::cout << "Number of entries: " << count << std::endl;
    for (size_t i = 0; i < dataArray.size(); ++i) {
        std::cout << "dataArray[" << i << "] = " << std::hex << dataArray[i] << std::endl;

        ap_uint<8> data = dataArray[i]; 
        udp_data.data(((i & 0x7)+1)*8-1, ((i & 0x7))*8) = data;
        udp_data.keep = 0xFF;
        if(i == dataArray.size() - 1)
        {
            udp_data.last = 1;
            i_axiu_stream_data.write(udp_data);
        }
        else if((i & 0x7) == 0x7)
        {
            udp_data.last = 0;
            i_axiu_stream_data.write(udp_data);
        }

    }
    // std::cout << std::endl;
    // for(int i=0; i<length; i++)
    // {
    //     ap_uint<8> data = byteArray[i];
    //     std::cout << std::hex << data << std::endl;
    //     udp_data.data(((i & 0x7)+1)*8-1, ((i & 0x7))*8) = data;
    //     udp_data.keep = 0xFF;
    //     if(i == length - 1)
    //     {
    //         udp_data.last = 1;
    //         i_axiu_stream_data.write(udp_data);
    //     }
    //     else if((i & 0x7) == 0x7)
    //     {
    //         udp_data.last = 0;
    //         i_axiu_stream_data.write(udp_data);
    //     }
    // }

    yusur_udp_filter(i_axiu_udp_param, i_axiu_stream_data, o_axiu_key, o_axiu_stream_data);









    return 0;
}
