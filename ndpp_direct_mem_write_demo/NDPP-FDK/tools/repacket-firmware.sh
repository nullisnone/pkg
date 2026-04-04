#!/bin/sh
#this is a tool for firmware repackaging.
#at the head of the firmware, we add 8 bytes devid, 
#8 bytes versionid, and 16 byte md5 checksum.


# input parameters
product_str=
ver_str=
sub_board_str=
filename=

product_index=
board_index=


product_id_array=("1f472019" "1f472018")
product_nm_array=("NDPP"     "Swift2200N")
product_snm_array=("ndpp"    "swift2200n")


ndpp_id_array=("040" "041" "042" "043" "044")
ndpp_name_array=("U50" "Conflux-x3000" "Conflux-x1100" "Conflux-x500" "JFM7V690T")
ndpp_sname_array=("u50" "x3000" "x1100" "x500" "jfm7v690t")


function show_help()
{
	echo "$0 -p <product> -s <sub-board> -v <version> -f <firmware-filename>"
	echo "e.g $0 -p NDPP -s x3000 -v 04110304 -f ./ndpp_fw.bin"
	echo "product: NDPP, Swift2200N"
	echo "sub board:NDPP{U50,     X3000,   X1100,   X500,    JFM7V690T}"
	echo "version:  NDPP{040XXXXX,041XXXXX,042XXXXX,043XXXXX,044XXXXX}"
}

function check_args()
{
	if [ -z $product_str ] || [ -z $ver_str ] || [ -z $filename ] || [ -z $sub_board_str ]; then
		echo "parameter not full, please check"
		show_help
		exit -1
	fi
	
	#check supported devid
	match_dev=0
	
	#check product_name match
	product_str=$(echo "$product_str" | tr '[:upper:]' '[:lower:]')
	
	for product_index in "${!product_id_array[@]}";
	do
		if [ ${product_snm_array[$product_index]} == $product_str ]; then
			echo "a ${product_nm_array[$product_index]} firmware."
			match_dev=1
			break
		fi
	done
	
	if [ $match_dev == 0 ]; then
		echo "not matched <devid>."
		exit -1
	fi
	
	#check versionid and sub board name
	sub_board_str=$(echo "$sub_board_str" | tr '[:upper:]' '[:lower:]')
	match_board=0
	
	if [ ${#ver_str} != 8 ]; then
		echo "version length error."
		exit -1
	fi
	for board_index in "${!ndpp_sname_array[@]}";
	do
		if [ ${ndpp_sname_array[$board_index]} == $sub_board_str ]; then
			echo "a ${ndpp_name_array[$board_index]} firmware."
			match_board=1
			break
		fi
	done
	
	if [ $match_board == 1 ]; then
		version_id="${ndpp_id_array[$board_index]}"
		version_id="${version_id:0:3}"
		ver_string="${ver_str:0:3}"
		if [ "$version_id" != "$ver_string" ]; then
			echo "version and board not match, please check."
			exit -1
		fi
	fi
	
	#check file exist
	if [ ! -f $filename ]; then
		echo "firmware file $filename does not exist. please check."
		exit -1
	fi
}

function repack_fw()
{
	new_fw_nm=${product_nm_array[$product_index]}-${ndpp_name_array[$board_index]}-$ver_str.bin

	csum_val=`md5sum $filename | cut -c 1-16`	
	if [ $? != 0 ]; then
		echo "get firmware checksum error, please check."
                rm -f $new_fw_nm
	fi

	echo -n "${product_id_array[$product_index]}${ver_str}$csum_val" > $new_fw_nm
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
while getopts "p:v:s:f:h" opt; do
  case $opt in
    p)
      product_str="$OPTARG"
      ;;
    v)
      ver_str="$OPTARG"
      ;;
	s)
	  sub_board_str="$OPTARG"
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
