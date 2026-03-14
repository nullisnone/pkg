#!/usr/bin/env bash

# 脚本信息
# Author: Fan
# Date: 2025-04-21
# Version: 1.10.1.33

# 定义全局变量
BDF="0000:01:00.0"
FIRMWARE_PRI=""
FIRMWARE_SEC=""
BIN_TYPE="multiboot_image"
DELAY=1
BRIDGE=""
command_number=0
LOG_FILE="/var/log/yusur_fw_update.log"
MAX_LOG_SIZE=$((10*1024*1024)) # 10MB
VENDOR_ID="1f47"
DEVICE_ID="2019"
X1100_BOARD_CODE="042"

# 初始化日志系统
function init_logging() {
    # 创建日志目录如果不存在
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # 检查并轮转日志文件
    if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -gt $MAX_LOG_SIZE ]; then
        mv "$LOG_FILE" "${LOG_FILE}.old"
    fi
    
    # 同时输出到屏幕和日志文件
    exec > >(tee -a "$LOG_FILE") 2>&1
    
    log "INFO" "=============================================="
    log "INFO" "Firmware Update Start: $(date)"
    log "INFO" "=============================================="
}

# 记录日志函数
function log() {
    local level=$1
    local message=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a "$LOG_FILE"
}

function ys_check_user() {
    if [ "$(id -u)" -ne 0 ]; then
        log "ERROR" "This script must be run with root privileges."
        exit 1
    elif [ -n "$SUDO_USER" ]; then
        log "WARNING" "Running via sudo (user: $SUDO_USER). Some operations may still be restricted."
    fi
}

function show_help(){
    echo ""
    echo "$0 -p <PCIE_ID> -f <IMAGE_FILE_PRI> -s <IMAGE_FILE_SEC>"
    echo -e "\e[34m e.g: $0 -p 0000:01:00.0 -f BASE_VERSION_X1100_primary.bin -s BASE_VERSION_X1100_secondary.bin \e[0m"
    echo ""
    echo "<PCIE_ID>         : PCIE bus number (To view the PCIE bus number, RUN command: lspci -d 1f47:2019"
    echo "<IMAGE_FILE_PRI>  : primary firmware bin file. eg: BASE_VERSION_X1100_primary.bin"
    echo "<IMAGE_FILE_SEC>  : secondary firmware bin file. eg: BASE_VERSION_X1100_secondary.bin"
    echo ""
}

function check_args(){
    if [ -z $BDF ] || [ -z $FIRMWARE_PRI ] || [ -z $FIRMWARE_SEC ]; then
        echo "parameter not full, please check"
        show_help
        exit -1
    fi
}

function ys_check_command() {
    if [ $# -lt 2 ]; then
       log "ERROR" "Insufficient arguments."
       echo "Usage:"
       echo "  $0 <BDF> <firmware_file>"
    #    echo "  $0 <BDF> <firmware_file> [delay]"
       echo "Example:"
       echo "  $0 0000:01:00.0 BASE_VERSION_U50.bin"
    #    echo "  $0 0000:01:00.0 BASE_VERSION_U50.bin 1"
       exit 1
    fi
}

function ys_check_file() {
    if [ ! -f "$1" ]; then
        log "ERROR" "Firmware file $1 does not exist."
        exit 1
    fi
}

function ys_check_delay() {
    if [ $# -eq 3 ]; then
       DELAY=$3
       log "INFO" "Setting activation delay to $DELAY seconds"
    fi
}

function ys_check_bdf() {
    if [[ ! $1 =~ ^000[0-9]:[0-9a-fA-F]{2}:00\.[0-9]$ ]]; then
       log "ERROR" "Invalid BDF format: $1. Expected format: 0000:01:00.0"
       exit 1
    else
       BDF_TEMP=$(echo "$1" | awk -F: '{print $2":"$3}')
       if ! lspci -n | grep -q "$BDF_TEMP.*${VENDOR_ID}:"; then
          log "ERROR" "$1 is not a YUSUR DPU card. Please check with: lspci -n | grep ${VENDOR_ID}:"
          exit 1
       fi
       # 新增：检查 device_id 是否为 2019
       DEVICE_ID_CHECK=$(lspci -n -s "$1" | awk -F' ' '{print $3}' | awk -F':' '{print $2}')
       if [[ "$DEVICE_ID_CHECK" != $DEVICE_ID ]]; then
          log "ERROR" "Unsupported Device ID: $DEVICE_ID_CHECK. Only 2018 and 2021 are allowed."
          exit 1
       fi
       log "INFO" "supported Device ID: $DEVICE_ID_CHECK."
    fi
}

function ys_check_board() {
    check_board_output=$(yusur_ctl update -b $1 -r 0-0-4)
    if [ -n "$check_board_output" ]; then
        BOARD_CODE=$(echo "$check_board_output" | awk -F' ' '{printf "%s", substr($4,1,3)}')
        if [ "$BOARD_CODE" != $X1100_BOARD_CODE ]; then
            log "ERROR" "$1 is not X1100 Card, Please Check"
            exit 1
        else 
            log "INFO" "Current Card : NDPP X1100 CARD"
        fi
    else
        log "ERROR" "Can't read NDPP board register, Please check with: yusur_ctl update -b $1 -r 0-0-4"
        exit 1
    fi
}

function ys_close_ndpp_tcpdump() {
    yusur_ctl update -b $BDF -w 0-2130-4-0x0
    yusur_ctl update -b $BDF -w 0-2138-4-0x0

    check_tcpdump_0_output=$(yusur_ctl update -b $BDF -r 0-2130-4)
    if [ -n "check_tcpdump_0_output" ]; then
        tcpdump_0=$(echo "$check_tcpdump_0_output" | awk -F' ' '{printf "%s", substr($4,1)}')
        if [ "$tcpdump_0" = "00000000" ]; then
            log "INFO" "TCPDUMP #0 is Closed"
        else
            log "ERROR" "TCPDUMP #0 Can't be closed, Please check with: yusur_ctl update -b $BDF -r 0-2130-4"
            exit 1
        fi
    else
        log "ERROR" "Can't read TCPDUMP #0 regfile, Please check with: yusur_ctl update -b $BDF -r 0-2130-4"
        exit 1
    fi

    check_tcpdump_1_output=$(yusur_ctl update -b $BDF -r 0-2138-4)
    if [ -n "check_tcpdump_1_output" ]; then
        tcpdump_1=$(echo "$check_tcpdump_1_output" | awk -F' ' '{printf "%s", substr($4,1)}')
        if [ "$tcpdump_1" = "00000000" ]; then
            log "INFO" "TCPDUMP #1 is Closed"
        else
            log "ERROR" "TCPDUMP #1 Can't be closed, Please check with: yusur_ctl update -b $BDF -r 0-2138-4"
            exit 1
        fi
    else
        log "ERROR" "Can't read TCPDUMP #1 regfile, Please check with: yusur_ctl update -b $BDF -r 0-2138-4"
        exit 1
    fi
}

function ys_close_ndpp_userdma() {
    yusur_ctl update -b $BDF -w 0-10000-4-0x0

    check_userdma_output=$(yusur_ctl update -b $BDF -r 0-10000-4)
    if [ -n "check_userdma_output" ]; then
        userdma=$(echo "$check_userdma_output" | awk -F' ' '{printf "%s", substr($4,1)}')
        if [ "$userdma" = "00000000" ]; then
            log "INFO" "USER DMA is Closed"
        else
            log "ERROR" "USER DMA Can't be closed, Please check with: yusur_ctl update -b $BDF -r 0-10000-4"
            exit 1
        fi
    else
        log "ERROR" "Can't read USER DMA regfile, Please check with: yusur_ctl update -b $BDF -r 0-10000-4"
        exit 1
    fi
}

function ys_pcie_disable_fatal_err() {
    if [ ! -e "/sys/bus/pci/devices/${BDF}" ]; then
        log "ERROR" "Cannot find PCI device: ${BDF}"
        exit 1
    fi

    BRIDGE=$(basename "$(dirname "$(readlink -f "/sys/bus/pci/devices/${BDF}")")")
    if [ ! -e "/sys/bus/pci/devices/${BRIDGE}" ]; then
        log "ERROR" "Cannot find PCI bridge: ${BRIDGE}"
        exit 1
    fi
    
    log "INFO" "Disabling PCIe fatal errors for bridge $BRIDGE"
    CMD=$(setpci -s "${BRIDGE}" COMMAND)
    setpci -s "${BRIDGE}" COMMAND=$(printf "%04x" $((0x${CMD} & ~0x0100)))
    CTRL=$(setpci -s "${BRIDGE}" CAP_EXP+8.w)
    setpci -s "${BRIDGE}" CAP_EXP+8.w=$(printf "%04x" $((0x${CTRL} & ~0x0004)))
}


function ys_pcie_rescan() {
    log "INFO" "Rescanning PCI bus for bridge $BRIDGE"
    echo 1 > "/sys/bus/pci/devices/$BRIDGE/rescan"
}

function ys_pcie_check() {
    BDF_TEMP=$(echo "$BDF" | awk -F: '{print $2":"$3}')
    if lspci -n | grep -q "$BDF_TEMP"; then
        log "INFO" "Upgrade successful. Device $BDF is present."
    else
        log "WARNING" "Upgrade successful, but device $BDF is not present. A system reboot may be required."
    fi
}

function ys_detection_use_driver() {
    log "INFO" "Terminating processes using the driver"
    fuser -k /dev/instanta_socket > /dev/null 2>&1
    fuser -k /dev/swiftn* > /dev/null 2>&1
}

function ys_pcie_close() {
    log "INFO" "Checking PCIe device $BDF for special handling"
    
    BDF_TEMP=$(echo "$BDF" | awk -F: '{print $2":"$3}')
    lspci_output=$(lspci -n | grep "$BDF_TEMP" | grep "${VENDOR_ID}:${DEVICE_ID}")
    
    if [ -n "$lspci_output" ]; then
        log "INFO" "Found ${VENDOR_ID}:${DEVICE_ID} device - applying special removal logic"
        
        BDF1=$(echo "$BDF" | sed 's/.$/1/')
        BDF_TEMP1=$(echo "$lspci_output" | awk '{split($1, arr, "."); arr[2] = 1; print arr[1] "." arr[2]}')
        lspci_output_1=$(lspci -n | grep "$BDF_TEMP1" | grep "${VENDOR_ID}:${DEVICE_ID}")
        
        if [ -n "$lspci_output_1" ]; then
            BDF_TEMP2=$(echo "$lspci_output" | awk '{split($1, arr, "."); arr[2] = 2; print arr[1] "." arr[2]}')
            lspci_output_2=$(lspci -n | grep "$BDF_TEMP2" | grep "${VENDOR_ID}:${DEVICE_ID}")
            
            if [ -n "$lspci_output_2" ]; then
                BDF2=$(echo "$BDF" | sed 's/.$/2/')
                BDF3=$(echo "$BDF" | sed 's/.$/3/')
                log "INFO" "Removing multiple functions: $BDF, $BDF1, $BDF2, $BDF3"
                echo 1 > "/sys/bus/pci/devices/${BDF}/remove"
                echo 1 > "/sys/bus/pci/devices/${BDF1}/remove"
                echo 1 > "/sys/bus/pci/devices/${BDF2}/remove"
                echo 1 > "/sys/bus/pci/devices/${BDF3}/remove"
            else 
                log "INFO" "Removing two functions: $BDF, $BDF1"
                echo 1 > "/sys/bus/pci/devices/${BDF}/remove"
                echo 1 > "/sys/bus/pci/devices/${BDF1}/remove"
            fi
        else
            log "INFO" "Removing single function: $BDF"
            echo 1 > "/sys/bus/pci/devices/${BDF}/remove"
        fi
    else
        log "INFO" "Standard PCIe device - removing single function: $BDF"
        echo 1 > "/sys/bus/pci/devices/${BDF}/remove"
    fi
}

function ys_program_firmware_primary() {
    log "INFO" "Programming firmware $FIRMWARE_PRI to device $BDF"
    
    local temp_file=$(mktemp)
    local ret=0
    if [ "$BIN_TYPE" = "golden_image" ]; then
        if ! yusur_ctl update -b "${BDF}" -p -f "${FIRMWARE_PRI}" -i 0 -d 0x0 2>&1 | tee "$temp_file"; then
            ret=$?
            log "ERROR" "yusur_ctl update failed with return code $ret"
        fi
    elif [ "$BIN_TYPE" = "multiboot_image" ]; then
        if ! yusur_ctl update -b "${BDF}" -p -f "${FIRMWARE_PRI}" -i 0 -d 0x00E00000 2>&1 | tee "$temp_file"; then
            ret=$?
            log "ERROR" "yusur_ctl update failed with return code $ret"
        fi
    else
        log "ERROR" "BIN_TYPE is not avlid"
        exit 1
    fi
    
    if grep -q "package version does not match hardware version!" "$temp_file"; then
        log "ERROR" "Firmware version mismatch"
        ret=1
    elif grep -q "update firmware failed, please check!" "$temp_file"; then
        log "ERROR" "Firmware update failed"
        ret=1
    fi
    
    rm "$temp_file"
    
    if [ $ret -ne 0 ]; then
        log "ERROR" "Firmware programming failed. Aborting update process."
        exit $ret
    fi
    
    log "INFO" "Firmware programming completed successfully"
}

function ys_program_firmware_secondary() {
    log "INFO" "Programming firmware $FIRMWARE_SEC to device $BDF"
    
    local temp_file=$(mktemp)
    local ret=0
    
    if [ "$BIN_TYPE" = "golden_image" ]; then
        if ! yusur_ctl update -b "${BDF}" -p -f "${FIRMWARE_SEC}" -i 1 -d 0x0 2>&1 | tee "$temp_file"; then
            ret=$?
            log "ERROR" "yusur_ctl update failed with return code $ret"
        fi
    elif [ "$BIN_TYPE" = "multiboot_image" ]; then
        if ! yusur_ctl update -b "${BDF}" -p -f "${FIRMWARE_SEC}" -i 1 -d 0x00E00000 2>&1 | tee "$temp_file"; then
            ret=$?
            log "ERROR" "yusur_ctl update failed with return code $ret"
        fi
    else
        log "ERROR" "BIN_TYPE is not avlid"
        exit 1
    fi
    
    if grep -q "package version does not match hardware version!" "$temp_file"; then
        log "ERROR" "Firmware version mismatch"
        ret=1
    elif grep -q "update firmware failed, please check!" "$temp_file"; then
        log "ERROR" "Firmware update failed"
        ret=1
    fi
    
    rm "$temp_file"
    
    if [ $ret -ne 0 ]; then
        log "ERROR" "Firmware programming failed. Aborting update process."
        exit $ret
    fi
    
    log "INFO" "Firmware programming completed successfully"
}

function ys_active_firmware() {
    log "INFO" "Activating firmware with delay $DELAY seconds"
    if ! yusur_ctl update -b "${BDF}" -a"${DELAY}"; then
        log "ERROR" "Firmware activation failed"
        exit 1
    fi
}

function cleanup() {
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        log "ERROR" "Script failed with exit code $exit_code"
    else
        log "INFO" "Script completed successfully"
    fi
    
    log "INFO" "=============================================="
    log "INFO" "Firmware Update End: $(date)"
    log "INFO" "=============================================="
    
    exit $exit_code
}

function main() {
    init_logging
    trap cleanup EXIT
    
    log "INFO" "Starting firmware update process"
    
    
    # 参数处理
    ys_check_user
    while getopts "p:f:s:t:h" opt; do
        case $opt in
            p)
            BDF="$OPTARG"
            ;;
            f)
            FIRMWARE_PRI="$OPTARG"
            ;;
            s)
            FIRMWARE_SEC="$OPTARG"
            ;;
            t)
            BIN_TYPE="$OPTARG"
            ;;
            h)
            show_help
            ;;
            \?)
            show_help
            exit -1
            ;;
        esac
    done
    
    check_args
    
    # ys_check_command "$@"
    # BDF=$1
    # FIRMWARE=$2
    ys_check_file "$FIRMWARE_PRI"
    ys_check_file "$FIRMWARE_SEC"
    ys_check_bdf "$BDF"
    ys_check_board "$BDF"
    ys_check_delay "$@"
    
    BRIDGE=$(basename "$(dirname "$(readlink -f "/sys/bus/pci/devices/${BDF}")")")
    
    log "INFO" "Using BDF: $BDF"
    log "INFO" "Using Primary firmware: $FIRMWARE_PRI"
    log "INFO" "Using Secondary firmware: $FIRMWARE_SEC"
    log "INFO" "Using bridge: $BRIDGE"
    log "INFO" "Using activation delay: $DELAY seconds"
    
    echo "#####################################################################################################"
    echo "#######                                                                                     #########"
    echo "#######                 Warning: Close TCPDUMP module and USER DMA module.                  #########"
    echo "#######                                                                                     #########"
    echo "#####################################################################################################"
    ys_close_ndpp_tcpdump
    ys_close_ndpp_userdma
    sleep 3

    # 显示警告信息
    echo "#####################################################################################################"
    echo "#######                                                                                     #########"
    echo "#######    Warning: Please do not interrupt this script during firmware upgrade process.    #########"
    echo "#######                                                                                     #########"
    echo "#####################################################################################################"
    
    # 执行固件更新流程
    ys_program_firmware_secondary
    sleep 1
    ys_program_firmware_primary
    ys_pcie_disable_fatal_err
    ys_detection_use_driver
    ys_active_firmware
    ys_pcie_close
    
    # 等待固件加载
    local wait_time=$((DELAY + 10))
    log "INFO" "Waiting $wait_time seconds for FPGA to load"
    sleep "$wait_time"
    
    # 恢复设备
    ys_pcie_rescan
    ys_pcie_check
}

main "$@"