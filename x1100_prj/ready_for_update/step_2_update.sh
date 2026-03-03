#!/usr/bin/env bash
bdf="01:00.0"
#firmware="swift2200n_t1.bin"
#firmware="./20130914_v1/yusur_ndpp_u50.bin"
firmware="yusur_ndpp_u50.bin"
delay=1

#Author: Liujihong
#date: 2022-10-19 09:54:11
#last_author: Liujihong (liujh@yusur.tech)
#last_edit_time: 2022-11-9 16:27:59




function ys_pcie_disable_fatal_err(){
    if [[ ! -e "/sys/bus/pci/devices/0000:$bdf" ]]; then
        echo "there is no pci device: $bdf, please check!"
        exit 1
    fi
    bridge=$(basename $(dirname $(readlink "/sys/bus/pci/devices/0000:$bdf")))
    if [[ ! -e "/sys/bus/pci/devices/$bridge" ]]; then
        echo "Error: device $bridge not found"
        exit 1
    fi
    cmd=$(setpci -s $bridge COMMAND)
    setpci -s $bridge COMMAND=$(printf "%04x" $((0x$cmd & ~0x0100)))
    ctrl=$(setpci -s $bridge CAP_EXP+8.w)
    setpci -s $bridge CAP_EXP+8.w=$(printf "%04x" $((0x$ctrl & ~0x0004)))
}

function ys_detection_use_driver(){
    fuser -k /dev/instanta_socket > /dev/null 2>&1
    fuser -k /dev/swiftn* > /dev/null 2>&1
}

function ys_remove_driver(){
    result=`lsmod | awk '$1 ~ /instanta/'`
    if [[ $result != '' ]]; then
        rmmod instanta
    fi
    if [ $? -ne 0 ];then
        echo "rmmod instanta failed!"
        exit 1
    fi
    result=`lsmod | awk '$1 ~ /swiftn/'`
    if [[ $result != '' ]]; then
        rmmod swiftn
    fi
    if [ $? -ne 0 ];then
        echo "rmmod swiftn failed!"
        exit 1
    fi
}

function ys_pcie_close(){
    echo 1 > /sys/bus/pci/devices/0000:$bdf/remove
}

#    yusur_ctl update -b $bdf -p -f $firmware
function ys_program_firmware(){
    /usr/local/bin/yusur_ctl update -b $bdf -p -f $firmware
}

function ys_active_firmware(){
   /usr/local/bin/yusur_ctl update -b $bdf -a$delay
}



argc=$#
if [[ argc -lt 2 ]];then
	echo "//----------------------------------------------------"
	echo "info : 	You need to \"sudo su\""
	echo ""
	echo "Arguments:"
	echo "	BDF	Users can use commadn \"lspci | grep 2019\" to get the BDF 01:00.0"
	echo "	BIN	Specifies the crc-binary file name after \"step_1_pkg.sh\""
	echo ""
	echo "e.g-1	sudo su"
	echo "e.g-2	$0 01:00.0 ndpp_u50_20231117.bin" 
	echo ""
	exit -1
fi

bdf=$1
firmware=$2
if [[ argc -eq 3 ]];then
	delay=$3
fi

ys_program_firmware $bdf $firmware
echo "start active new firmware..."
ys_pcie_disable_fatal_err $bdf
#关闭使用驱动的用户态进程
ys_detection_use_driver

#时延的设置目的是为了启动加载时，pcie已经close了。
ys_active_firmware $bdf $delay
#卸载驱动
ys_remove_driver
ys_pcie_close $bdf

#确保reboot时，fpga已经加载完成
let delay+=5
sleep $delay
echo "update success, restart system to active new hardware package, reboot..."
#reboot
