#!/bin/bash

# # 检查输入参数
# if [ "$#" -ne 2 ]; then
#     echo "用法: $0 <pcie_id> <寄存器地址>"
#     exit 1
# fi

pcie_id=
module_name=
module_id=

IFS_SAVE=$IFS
declare -A register_array
declare -i result_line_id=0

result_start_length=0

function show_help()
{
    echo "$0 -p <PCIE_ID> -m <MODULE_NAME> -i <MODULE_ID>"
    echo "e.g: $0 -p 01:00.0 -m user_dma -i rx0"
    echo ""
    echo "<PCIE_ID> : PCIE bus number (To view the PCIE bus number, RUN command: lspci -d 1f47:2019"
    echo "<MODULE_NAME> : <user_dma> / <mac>"
    echo "<MODULE_ID> : user_dma : <rx0>, <rx1>, <rx2>, <rx3>, <tx>"
    echo "<MODULE_ID> : mac : <mac0>, <mac1>, <mac2>, <mac3>"
    echo "<MODULE_ID> : clear : <mac0> ... <mac3>; <rx0> ... <rx3>; <tx>"
}

function read_user_dma_rx()
{
    local   user_dma_id=$1
    local   dma_register_address= 

    ## 根据输入赋值寄存器地址
    if [ "$user_dma_id" = "rx0" ]; then
        dma_register_address="0-10100-64"
    elif [ "$user_dma_id" = "rx1" ]; then
        dma_register_address="0-10150-64"
    elif [ "$user_dma_id" = "rx2" ]; then
        dma_register_address="0-10200-64"
    elif [ "$user_dma_id" = "rx3" ]; then
        dma_register_address="0-10250-64"
    else
        echo "USER DMA ID ERROR, Please Check"
        show_help
        exit
    fi

    ## 执行"yusur_ctl update"读寄存器指令
    reg_result=$(yusur_ctl update -b "$pcie_id" -r "$dma_register_address")
    
    # 检查命令是否成功执行
    if [ $? -ne 0 ]; then
        echo "The command failed to be executed. Please check the input information"
        exit 1
    fi
    # echo "$reg_result"
    # 使用 IFS 分割输出为行
    IFS=$'\n'

    # 遍历每一行
    for line in $reg_result; do
        # echo "$line"
        # 使用正则表达式匹配地址范围和数据
        if [[ $line =~ ^(0x[0-9a-fA-F]+)\ ~\ ([0-9a-fA-F]+)\ +(.*)$ ]]; then
            start_address=${BASH_REMATCH[1]}  # 起始地址
            end_address=${BASH_REMATCH[2]}    # 结束地址
            data=${BASH_REMATCH[3]}           # 获取数据部分
            # 将数据按空格分割为数组
            IFS=$'\ \t'
            read -a data_array <<< "$data"
            # echo "${data_array[*]}"
            ## 获取读取的寄存器信息
            for ((i=0; i<${#data_array[@]}; i++)); do
                # 计算当前寄存器地址
                # egister_address=$(printf "0x%08x" $((0x${start_address:2} + i * 4)))
                # echo "$register_address: ${data_array[i]}"
                
                # 将当前寄存器地址保存至二维数组中
                register_array["$result_line_id,$i"]="${data_array[i]}"
            done
            IFS=$'\n'
        fi
        result_line_id=$result_line_id+1
    done

    ## 输出USER DMA寄存器信息
    echo "******************************************************"
    echo "********    USER DMA RX PORT $user_dma_id STATISTIC    ********"
    echo "******************************************************"
    echo "RXDMA TOTAL RECV PACKET        : 0x${register_array[$((result_start_length+0)),1]}_${register_array[$((result_start_length+0)),2]}"
    echo "RXDMA TOTAL BUFFER RECV PACKET : 0x${register_array[$((result_start_length+0)),3]}_${register_array[$((result_start_length+1)),0]}"
    echo "RXDMA LAST CHUNK TIME          : 0x${register_array[$((result_start_length+1)),1]}"
    echo "RXDMA TOTAL TLP PACKET         : 0x${register_array[$((result_start_length+1)),2]}_${register_array[$((result_start_length+1)),3]}"
    echo "RXDMA CHANNEL 0  RECV PACKET   : 0x${register_array[$((result_start_length+2)),0]:0:4}"
    echo "RXDMA CHANNEL 1  RECV PACKET   : 0x${register_array[$((result_start_length+2)),0]:4:4}"
    echo "RXDMA CHANNEL 2  RECV PACKET   : 0x${register_array[$((result_start_length+2)),1]:0:4}"
    echo "RXDMA CHANNEL 3  RECV PACKET   : 0x${register_array[$((result_start_length+2)),1]:4:4}"
    echo "RXDMA CHANNEL 4  RECV PACKET   : 0x${register_array[$((result_start_length+2)),2]:0:4}"
    echo "RXDMA CHANNEL 5  RECV PACKET   : 0x${register_array[$((result_start_length+2)),2]:4:4}"
    echo "RXDMA CHANNEL 6  RECV PACKET   : 0x${register_array[$((result_start_length+2)),3]:0:4}"
    echo "RXDMA CHANNEL 7  RECV PACKET   : 0x${register_array[$((result_start_length+2)),3]:4:4}"
    echo "RXDMA CHANNEL 8  RECV PACKET   : 0x${register_array[$((result_start_length+3)),0]:0:4}"
    echo "RXDMA CHANNEL 9  RECV PACKET   : 0x${register_array[$((result_start_length+3)),0]:4:4}"
    echo "RXDMA CHANNEL 10 RECV PACKET   : 0x${register_array[$((result_start_length+3)),1]:0:4}"
    echo "RXDMA CHANNEL 11 RECV PACKET   : 0x${register_array[$((result_start_length+3)),1]:4:4}"
    echo "RXDMA CHANNEL 12 RECV PACKET   : 0x${register_array[$((result_start_length+3)),2]:0:4}"
    echo "RXDMA CHANNEL 13 RECV PACKET   : 0x${register_array[$((result_start_length+3)),2]:4:4}"
    echo "RXDMA CHANNEL 14 RECV PACKET   : 0x${register_array[$((result_start_length+3)),3]:0:4}"
    echo "RXDMA CHANNEL 15 RECV PACKET   : 0x${register_array[$((result_start_length+3)),3]:4:4}"
    echo "******************************************************"
}

function read_user_dma_tx()
{
    local   user_dma_id=$1
    local   dma_register_address= 

    ## 根据输入赋值寄存器地址
    if [ "$user_dma_id" = "tx" ]; then
        dma_register_address="0-10300-80"
    else
        echo "USER DMA ID ERROR, Please Check"
        show_help
        exit
    fi

    ## 执行"yusur_ctl update"读寄存器指令
    reg_result=$(yusur_ctl update -b "$pcie_id" -r "$dma_register_address")
    
    # 检查命令是否成功执行
    if [ $? -ne 0 ]; then
        echo "The command failed to be executed. Please check the input information"
        exit 1
    fi
    # echo "$reg_result"
    # 使用 IFS 分割输出为行
    IFS=$'\n'

    # 遍历每一行
    for line in $reg_result; do
        # echo "$line"
        # 使用正则表达式匹配地址范围和数据
        if [[ $line =~ ^(0x[0-9a-fA-F]+)\ ~\ ([0-9a-fA-F]+)\ +(.*)$ ]]; then
            start_address=${BASH_REMATCH[1]}  # 起始地址
            end_address=${BASH_REMATCH[2]}    # 结束地址
            data=${BASH_REMATCH[3]}           # 获取数据部分
            # 将数据按空格分割为数组
            IFS=$'\ \t'
            read -a data_array <<< "$data"
            # echo "${data_array[*]}"
            ## 获取读取的寄存器信息
            for ((i=0; i<${#data_array[@]}; i++)); do
                # 计算当前寄存器地址
                # egister_address=$(printf "0x%08x" $((0x${start_address:2} + i * 4)))
                # echo "$register_address: ${data_array[i]}"
                
                # 将当前寄存器地址保存至二维数组中
                register_array["$result_line_id,$i"]="${data_array[i]}"
            done
            IFS=$'\n'
        fi
        result_line_id=$result_line_id+1
    done

    ## 输出USER DMA寄存器信息
    echo "******************************************************"
    echo "**********    USER DMA TX PORT STATISTIC    **********"
    echo "******************************************************"
    echo "TXDMA TOTAL SEND PACKET        : 0x${register_array[$((result_start_length+0)),1]}_${register_array[$((result_start_length+0)),2]}"
    echo "TXDMA PORT 0 TORAL SEND PACKET : 0x${register_array[$((result_start_length+0)),3]}_${register_array[$((result_start_length+1)),0]}"
    echo "TXDMA PORT 1 TORAL SEND PACKET : 0x${register_array[$((result_start_length+1)),1]}_${register_array[$((result_start_length+1)),2]}"
    echo "TXDMA PORT 2 TORAL SEND PACKET : 0x${register_array[$((result_start_length+1)),3]}_${register_array[$((result_start_length+2)),0]}"
    echo "TXDMA PORT 3 TORAL SEND PACKET : 0x${register_array[$((result_start_length+2)),1]}_${register_array[$((result_start_length+2)),2]}"
    echo "TXDMA CHANNEL 0  SEND PACKET   : 0x${register_array[$((result_start_length+2)),3]:0:4}"
    echo "TXDMA CHANNEL 1  SEND PACKET   : 0x${register_array[$((result_start_length+2)),3]:4:4}"
    echo "TXDMA CHANNEL 2  SEND PACKET   : 0x${register_array[$((result_start_length+3)),0]:0:4}"
    echo "TXDMA CHANNEL 3  SEND PACKET   : 0x${register_array[$((result_start_length+3)),0]:4:4}"
    echo "TXDMA CHANNEL 4  SEND PACKET   : 0x${register_array[$((result_start_length+3)),1]:0:4}"
    echo "TXDMA CHANNEL 5  SEND PACKET   : 0x${register_array[$((result_start_length+3)),1]:4:4}"
    echo "TXDMA CHANNEL 6  SEND PACKET   : 0x${register_array[$((result_start_length+3)),2]:0:4}"
    echo "TXDMA CHANNEL 7  SEND PACKET   : 0x${register_array[$((result_start_length+3)),2]:4:4}"
    echo "TXDMA CHANNEL 8  SEND PACKET   : 0x${register_array[$((result_start_length+3)),3]:0:4}"
    echo "TXDMA CHANNEL 9  SEND PACKET   : 0x${register_array[$((result_start_length+3)),3]:4:4}"
    echo "TXDMA CHANNEL 10 SEND PACKET   : 0x${register_array[$((result_start_length+4)),0]:0:4}"
    echo "TXDMA CHANNEL 11 SEND PACKET   : 0x${register_array[$((result_start_length+4)),0]:4:4}"
    echo "TXDMA CHANNEL 12 SEND PACKET   : 0x${register_array[$((result_start_length+4)),1]:0:4}"
    echo "TXDMA CHANNEL 13 SEND PACKET   : 0x${register_array[$((result_start_length+4)),1]:4:4}"
    echo "TXDMA CHANNEL 14 SEND PACKET   : 0x${register_array[$((result_start_length+4)),2]:0:4}"
    echo "TXDMA CHANNEL 15 SEND PACKET   : 0x${register_array[$((result_start_length+4)),2]:4:4}"
    echo "******************************************************"
}

function read_mac()
{
    local   mac_id=$1
    local   mac_register_address= 
    local   mac_rx_status=
    local   mac_tramsmit_status=
    local   mac_status=

    ## 根据输入赋值寄存器地址
    if [ "$mac_id" = "mac0" ]; then
        mac_register_address="0-400-48"
    elif [ "$mac_id" = "mac1" ]; then
        mac_register_address="0-440-48"
    elif [ "$mac_id" = "mac2" ]; then
        mac_register_address="0-480-48"
    elif [ "$mac_id" = "mac3" ]; then
        mac_register_address="0-4C0-48"
    else
        echo "MAC ID ERROR, Please Check"
        show_help
        exit
    fi

    ## 执行"yusur_ctl update"读寄存器指令
    reg_result=$(yusur_ctl update -b "$pcie_id" -r "$mac_register_address")
    
    # 检查命令是否成功执行
    if [ $? -ne 0 ]; then
        echo "The command failed to be executed. Please check the input information"
        exit 1
    fi
    # echo "$reg_result"
    # 使用 IFS 分割输出为行
    IFS=$'\n'

    # 遍历每一行
    for line in $reg_result; do
        # echo "$line"
        # 使用正则表达式匹配地址范围和数据
        if [[ $line =~ ^(0x[0-9a-fA-F]+)\ ~\ ([0-9a-fA-F]+)\ +(.*)$ ]]; then
            start_address=${BASH_REMATCH[1]}  # 起始地址
            end_address=${BASH_REMATCH[2]}    # 结束地址
            data=${BASH_REMATCH[3]}           # 获取数据部分
            # 将数据按空格分割为数组
            IFS=$'\ \t'
            read -a data_array <<< "$data"
            # echo "${data_array[*]}"
            ## 获取读取的寄存器信息
            for ((i=0; i<${#data_array[@]}; i++)); do
                # 计算当前寄存器地址
                # egister_address=$(printf "0x%08x" $((0x${start_address:2} + i * 4)))
                # echo "$register_address: ${data_array[i]}"
                
                # 将当前寄存器地址保存至二维数组中
                register_array["$result_line_id,$i"]="${data_array[i]}"
            done
            IFS=$'\n'
        fi
        result_line_id=$result_line_id+1
    done
    mac_rx_status=$(printf '%04d\n' "$(bc <<< "obase=2; ibase=16; ${register_array[$((result_start_length+2)),0]:7:1}")")
    mac_tramsmit_status=$(printf '%04d\n' "$(bc <<< "obase=2; ibase=16; ${register_array[$((result_start_length+2)),1]:7:1}")")
    mac_status=$(printf '%04d\n' "$(bc <<< "obase=2; ibase=16; ${register_array[$((result_start_length+2)),2]:7:1}")")
    mac_sfp_status_0=$(printf '%04d\n' "$(bc <<< "obase=2; ibase=16; ${register_array[$((result_start_length+2)),2]:6:1}")")
    mac_sfp_status_1=$(printf '%04d\n' "$(bc <<< "obase=2; ibase=16; ${register_array[$((result_start_length+2)),2]:5:1}")")
    
    ## 输出MAC寄存器信息
    echo "******************************************************"
    echo "********    MAC PORT $mac_id STATISTIC    ********"
    echo "******************************************************"
    echo "MAC ENABLE SIGNAL              : 0x${mac_status:3:1}"
    echo "MAC LOOPBACK SIGNAL            : 0x${mac_status:2:1}"
    echo "MAC LINK SIGNAL                : 0x${mac_status:1:1}"
    echo "MAC REMOTE FAULT               : 0x${mac_rx_status:3:1}"
    echo "MAC LOCAL FAULT                : 0x${mac_rx_status:2:1}"
    echo "MAC TRANSMIT FAULT             : 0x${mac_tramsmit_status:3:1}"
    echo ""
    echo "MAC SFP STATUS - TX_DISABLE    : 0x${mac_sfp_status_0:3:1}"
    echo "MAC SFP STATUS - TX_FAULT      : 0x${mac_sfp_status_0:2:1}"
    echo "MAC SFP STATUS - MOD_ABS       : 0x${mac_sfp_status_0:1:1}"
    echo "MAC SFP STATUS - RX_LOS        : 0x${mac_sfp_status_0:0:1}"
    echo "MAC SFP STATUS - RS0           : 0x${mac_sfp_status_1:3:1}"
    echo "MAC SFP STATUS - RS1           : 0x${mac_sfp_status_1:2:1}"
    echo ""
    echo "MAC TOTAL SEND PACKET          : 0x${register_array[$((result_start_length+0)),1]}"
    echo "MAC TOTAL RECV PACKET          : 0x${register_array[$((result_start_length+0)),2]}"
    echo "MAC TOTAL RECV IGNORED PACKET  : 0x${register_array[$((result_start_length+0)),3]}"
    echo "MAC TOTAL RECV BAD FCS PACKET  : 0x${register_array[$((result_start_length+1)),0]}"
    echo "MAC TOTAL RECV DROP PACKET     : 0x${register_array[$((result_start_length+1)),1]}"
    echo "MAC TOTAL RECV BAD FRAME PACKET: 0x${register_array[$((result_start_length+1)),2]}"
    echo "MAC TOTAL SEND BAD FCS PACKET  : 0x${register_array[$((result_start_length+1)),3]}"
    echo "******************************************************"
}

function clear_reg()
{
    local   mac_id=$1
    local   mac_register_address= 

    ## 根据输入赋值寄存器地址
    if [ "$mac_id" = "mac0" ]; then
        mac_register_address="0-400-4"
    elif [ "$mac_id" = "mac1" ]; then
        mac_register_address="0-440-4"
    elif [ "$mac_id" = "mac2" ]; then
        mac_register_address="0-480-4"
    elif [ "$mac_id" = "mac3" ]; then
        mac_register_address="0-4C0-4"
    elif [ "$mac_id" = "rx0" ]; then
        mac_register_address="0-10100-4"
    elif [ "$mac_id" = "rx1" ]; then
        mac_register_address="0-10150-4"
    elif [ "$mac_id" = "rx2" ]; then
        mac_register_address="0-10200-4"
    elif [ "$mac_id" = "rx3" ]; then
        mac_register_address="0-10250-4"
    elif [ "$mac_id" = "tx" ]; then
        dma_register_address="0-10300-4"
    else
        echo "MODULE ID ERROR, Please Check"
        show_help
        exit
    fi

    yusur_ctl update -b "$pcie_id" -w "$mac_register_address"-1

    yusur_ctl update -b "$pcie_id" -w "$mac_register_address"-0
}

function check_args()
{
    if [ -z $pcie_id ] || [ -z $module_name ] || [ -z $module_id ]; then
		echo "parameter not full, please check"
		show_help
		exit -1
	fi

    if [ "$module_name" = "user_dma" ]; then
        if [ "$module_id" = "tx" ]; then
            read_user_dma_tx $module_id
        else
            read_user_dma_rx $module_id
        fi
    elif [ "$module_name" = "mac" ]; then
        read_mac $module_id
    elif [ "$module_name" = "clear" ]; then
        clear_reg $module_id
    else
        echo "<MODULE_NAME> ERROR, Please Check"
        show_help
    fi
}

while getopts "p:m:i:h" opt; do
  case $opt in
    p)
      pcie_id="$OPTARG"
      ;;
    m)
      module_name="$OPTARG"
      ;;
	i)
	  module_id="$OPTARG"
	  ;;
    \?)
      show_help
      exit -1
      ;;
  esac
done

check_args

IFS=$IFS_SAVE
