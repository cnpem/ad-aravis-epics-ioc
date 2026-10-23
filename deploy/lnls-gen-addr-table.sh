#!/bin/sh

set -eu

config_dir=$PWD

if [ $# -eq 1 ]; then
  config_dir=$1
elif [ $# -gt 1 ]; then
  echo "usage: $0 [<config-dir>]"
  exit 1
fi

get_config_value() {
  file=$1
  key=$2

  grep $key $file | cut -d',' -f 2 | cut -d')' -f 1 | sed -e "s|\s*||g" | sed -e 's|"||g'
}

get_camera_feature() {
  ip_address=$1
  param=$2

  arv-tool-0.8 -a $ip_address control $param | cut -d'=' -f 2 | sed -e "s|\s*||g"
}

config_files=$(find $config_dir -iname "*BASLER*.cmd" | sort)

if [ -n "$config_files" ]; then
  printf "| IOC script\t\t| IP Address\t| MAC Address\t|\tDevice\n"
else
  >&2 echo "No Basler iocsh file found in '$(realpath $config_dir)'."
fi

for config in $config_files; do
  ip_address=$(get_config_value $config IP_ADDRESS)

  if [ "$(arv-tool-0.8 -a $ip_address 2>/dev/null)" != "$ip_address" ]; then
    >&2 echo "Camera '$(basename $config)' ($ip_address) not available in the network."

    continue
  fi

  mac_address=$(get_camera_feature $ip_address GevMACAddress)

  model=$(get_camera_feature $ip_address DeviceModelName)
  version=$(get_camera_feature $ip_address DeviceVersion)
  serial_number=$(get_camera_feature $ip_address DeviceID)

  printf '| %s \t| %s \t| %x \t| %s\n' \
    $(basename $config) \
    $ip_address \
    $mac_address \
    "${model}_${version}_${serial_number}"
done
