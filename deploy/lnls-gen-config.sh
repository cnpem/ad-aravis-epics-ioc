#!/usr/bin/env bash

set -ue

repository_name=cnpem/ad-aravis-epics-ioc
repository_raw=https://raw.githubusercontent.com/$repository_name
repository_api=https://api.github.com/repos/$repository_name
repository_cr=ghcr.io/$repository_name

interactive=yes

if [ $# -ge 1 ]; then
    if [ "$1" = "-y" ]; then
        interactive=;
        shift
    elif [ "$1" = "-h" ]; then
        cat <<EOF
usage: $0 [-y|-h] [<camera_ip>...]

Generate YAML snippet with variables relevant for deploying the IOC.

Arguments:
    camera_ip  IP address of the camera to be configured, possibly in another
               subnetwork. It can be multiple addresses. If not specified,
               cameras are searched in the local subnetwork.

Options:
    -y      Use default value from all prompts and run non-interactively.
    -h      Show this help message
EOF

        exit 0
    fi
fi

get_feature() {
    ip=$1
    feature=$2

    response=$(arv-tool-0.8 -a $ip control $feature)

    echo ${response#*=}
}


prompt() {
    variable=$1 && shift
    message="$@"

    if [ -n "$interactive" ]; then
        printf "$message"
        read $variable
    else
        declare -g $variable=
    fi
}


get_local_cameras() {
    cameras=$(arv-tool-0.8 2>&1)

    if [[ $cameras =~ "No device" ]]; then
        >&2 echo "No device found in the current subnetwork."
        exit 1
    fi

    while read camera; do
        camera_ip=${camera#*(}
        camera_ip=${camera_ip%)*}
        echo $camera_ip
    done < <(echo "$cameras")
}

if [ $# -gt 0 ]; then
    cameras="$@"
else
    cameras=$(get_local_cameras)
fi

latest=$(wget -q $repository_api/tags -O - | grep "\"name\":" | head -n 1)
latest=${latest#*:}
latest=${latest#*\"}
latest=${latest%\"*}

prompt version "$repository_name version to use (default $latest): "

[ -n "$version" ] || version=$latest

echo

for camera_ip in $cameras; do
    echo "Generating configuration for camera $camera_ip"

    serial_number=$(get_feature $camera_ip DeviceID)

    prompt prefix "Prefix for camera PVs: "
    [ -n "$prefix" ] || prefix=''

    manufacturer=$(get_feature $camera_ip DeviceVendorName | sed -e "s| ||g")
    model=$(get_feature $camera_ip DeviceModelName | sed -e "s| |-|g")

    device_version=$(get_feature $camera_ip DeviceVersion)
    width=$(get_feature $camera_ip SensorWidth | cut -d' ' -f 1)
    height=$(get_feature $camera_ip SensorHeight | cut -d' ' -f 1)

    prompt colored "Does the camera support RGB images (yes/no) (default yes)? "

    max_num_pixels=$(( $width * $height ))
    [ "$colored" != "no" ] && max_num_pixels=$(( 3 * $max_num_pixels ))

    prompt limit "Acquisition period limit in seconds (default 0.1): "
    [ -n "$limit" ] || limit=0.1

    default_filename=$camera_ip.yml
    prompt filename "Generated iocsh script name (default '$default_filename'): "
    [ -n "$filename" ] || filename=$default_filename

    cat << EOF > $filename
    image: ghcr.io/cnpem/ad-aravis-epics-ioc:$version
    environment:
      PREFIX: "$prefix"
      IP_ADDRESS: "$camera_ip"
      DEVICE_MANUFACTURER: "$manufacturer"
      DEVICE_MODEL: "$model"
      DEVICE_VERSION: "$device_version"
      MAX_IMAGE_WIDTH: $width
      MAX_IMAGE_HEIGHT: $height
      MAX_IMAGE_PIXELS: $max_num_pixels
EOF
    [ -n "$limit" ] && cat << EOF >> $filename
      ACQUIRE_PERIOD_LOW_LIMIT: $limit
EOF

    printf "Saved to $(realpath $filename)\n\n"
done
