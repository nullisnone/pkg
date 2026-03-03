

文件说明
1. HLS_Kernel                               //该文件夹为VITIS_HLS工程路径
├── common  
├── hls 
│   ├── run_hls.tcl                         //设置编译ip
│   └── settings.tcl    
├── host    
├── ip_repo                                 //生成ip的路径
└── kernel  
    ├── common.h    
    ├── kernel.h    
    ├── yusur_hash_allocation.cpp           //分配USER DMA通道的源码
    └── yusur_udp_filter.cpp                //过滤UDP五元组的源码


2. 
x1100_prj                                   //该文件夹为vivado工程路径
.
├── prj 
│   ├── ip_repo                             //VITIS_HLS生成的ip
│   ├── ndpp_src                            //rtl源码，FDK底座，以及约束文件
│   └── project_1                           //vivado工程 
└── ready_for_update                        //烧写文件
    ├── NDPP-Conflux-x1100-04210850.bin     //yusur_ctl在线烧写文件
    ├── step_1_pkg.sh
    ├── step_2_update.sh
    ├── yusur_ndpp_x1100.bin                
    ├── yusur_ndpp_x1100.bit                //JTAG烧写文件
    └── yusur_ndpp_x1100.ltx