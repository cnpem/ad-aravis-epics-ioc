#!/usr/bin/env bash

set -ue

repository_name=cnpem/ad-aravis-epics-ioc
repository_raw=https://raw.githubusercontent.com/$repository_name
repository_api=https://api.github.com/repos/$repository_name
repository_cr=ghcr.io/$repository_name


if [ $# -ge 1 ]; then
    echo "usage: $0"

    exit 1
fi

replace_value() {
    file=$1
    key=$2
    value="$3"

    sed -i -e "s|epicsEnvSet(\"$key\", .*)|epicsEnvSet(\"$key\", $value)|" $file
}


get_feature() {
    ip=$1
    feature=$2

    response=$(arv-tool-0.8 -a $ip control $feature)

    echo ${response#*=}
}


cameras=$(arv-tool-0.8 2>&1)

if [[ $cameras =~ "No device" ]]; then
    echo "No device found in the current subnetwork."
    exit 1
fi

latest=$(wget -q $repository_api/tags -O - | grep "\"name\":" | head -n 1)
latest=${latest#*:}
latest=${latest#*\"}
latest=${latest%\"*}

echo -n "$repository_name version to use (default $latest): "

read version
[ -n "$version" ] || version=$latest

echo

while read -u 3 camera; do
    camera_ip=${camera#*(}
    camera_ip=${camera_ip%)*}

    echo "Generating configuration for camera $camera"

    serial_number=$(get_feature $camera_ip DeviceID)

    filename=$camera_ip.cmd
    iocsh_cmd=/tmp/$filename

    wget $repository_raw/$version/iocBoot/iocCamera/st.cmd -O $iocsh_cmd &> /tmp/wget-$camera_ip.log \
        || (cat /tmp/wget-$camera_ip.log && false)

    sed -i -e "s|$repository_cr|$repository_cr:$version|" $iocsh_cmd

    echo -n "Prefix for camera PVs: "
    read prefix

    replace_value $iocsh_cmd PREFIX $prefix
    replace_value $iocsh_cmd IP_ADDRESS $camera_ip

    manufacturer=$(get_feature $camera_ip DeviceVendorName | sed -e "s| ||g")
    replace_value $iocsh_cmd DEVICE_MANUFACTURER $manufacturer

    model=$(get_feature $camera_ip DeviceModelName | sed -e "s| |-|g")
    replace_value $iocsh_cmd DEVICE_MODEL $model
    replace_value $iocsh_cmd DEVICE_VERSION $(get_feature $camera_ip DeviceVersion)

    width=$(get_feature $camera_ip SensorWidth | cut -d' ' -f 1)
    height=$(get_feature $camera_ip SensorHeight | cut -d' ' -f 1)

    replace_value $iocsh_cmd MAX_IMAGE_WIDTH $width
    replace_value $iocsh_cmd MAX_IMAGE_HEIGHT $height

    echo -n "Does the camera support RGB images (yes/no) (default yes)? "
    read colored

    max_num_pixels=$(( $width * $height ))
    [ "$colored" != "no" ] && max_num_pixels=$(( 3 * $max_num_pixels ))

    replace_value $iocsh_cmd MAX_IMAGE_PIXELS $max_num_pixels

    echo -n "Acquisition period limit in seconds (default 0.1): "
    read limit
    [ -n "$limit" ] || limit=0.1

    replace_value $iocsh_cmd ACQUIRE_PERIOD_LOW_LIMIT $limit

    echo -n "Generated iocsh script name (default '$filename'): "
    read filename
    [ -n "$filename" ] || filename=$(basename $iocsh_cmd)

    mv $iocsh_cmd $filename

    printf "Saved to $(realpath $filename)\n\n"
done 3< <(echo "$cameras")
