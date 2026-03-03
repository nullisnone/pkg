#!/bin/sh
#this is a tool for firmware repackaging.
#at the head of the firmware, we add 8 bytes devid, 
#8 bytes versionid, and 16 byte md5 checksum.


dev_id=1f472019
ver_id=
filename=
devnm=


devid_array=("1f472019" "1f474096")
devnm_array=("ndpp_u50"    "x8000")


function show_help()
{
# ------v0.0
#	echo "$0 -d <devid> -v <versionid> -f <firmware-filename>"
#	echo "e.g $0 -d 1f472019 -v 20231117 -f ./yusur_ndpp_u50.bin"
# ------v1.0
	echo "info :	Tool for NDPP."
	echo ""
	echo "Arguments:"
	echo "	-v	Specifies version information with 8-characters(0~9,a~z,A~Z), like date or names"
	echo "	-f	Specifies the binary file name from Vivado Project"
	echo ""
	echo "usage: $0 -v <versionid> -f <firmware-filename>"
	echo "e.g    $0 -v 20231117 -f ./yusur_ndpp_u50.bin"
	echo "	---> ndpp_u50_20231117.bin"
	echo "e.g    $0 -v James001 -f ./yusur_ndpp_u50.bin"
	echo "	---> ndpp_u50_James001.bin"
	echo ""
}

function check_args()
{
	if [ -z $dev_id ] || [ -z $ver_id ] || [ -z $filename ]; then
		echo "not specify devid version_id or filename, please check"
		echo "//----------------------------------------------------"
		show_help
		exit -1
	fi
	
	#check supported devid
	match_dev=0
	for i in "${!devid_array[@]}";
	do
		if [[ ${devid_array[$i]} == $dev_id ]]; then
			echo "a ${devnm_array[$i]} firmware."
                        devnm=${devnm_array[$i]}
			match_dev=1
			break
		fi
	done
	if [ $match_dev == 0 ]; then
		echo "not matched <devid>."
		exit -1
	fi
	
	#check versionid
	if [ ${#ver_id} != 8 ]; then
		echo "version length error."
		exit -1
	fi
	
	#check file exist
	if [ ! -f $filename ]; then
		echo "firmware file $filename does not exist. please check."
	fi
}

function repack_fw()
{
	new_fw_nm=$devnm\_$ver_id.bin

	csum_val=`md5sum $filename | cut -c 1-16`	
	if [ $? != 0 ]; then
		echo "get firmware checksum error, please check."
                rm -f $new_fw_nm
	fi

	echo -n "${dev_id}${ver_id}$csum_val" > $new_fw_nm
	if [ $? != 0 ]; then
		echo "repackage the new firmware error!!"
                rm -f $new_fw_nm
	fi
	
	cat $filename >> $new_fw_nm 
	if [ $? != 0 ]; then
		echo "repackage the new firmware error!!"
                rm -f $new_fw_nm
	fi
	echo "new firmware $(pwd)/$new_fw_nm generated."
}

#start this script
while getopts "d:v:f:h" opt; do
  case $opt in
    d)
      dev_id="$OPTARG"
      ;;
    v)
      ver_id="$OPTARG"
      ;;
    f)
      filename="$OPTARG"
      ;;
    \?)
      show_help
      exit -1
      ;;
  esac
done

check_args
repack_fw
