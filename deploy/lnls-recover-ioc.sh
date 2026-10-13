#!/usr/bin/env bash

set -eu

if [ $# -lt 1 ]; then
  cat << EOF
usage: $0 <ioc-name>...

Arguments:

ioc-name   name of the IOCs to recover; naming should be as expected by iocs
           script
EOF

  exit 1
fi

IOC_PATH=/usr/local/epics/apps/config

get_ip() {
  ioc_name=$1
  grep IP_ADDRESS ${IOC_PATH}/${ioc_name}.cmd | grep -oE "([0-9]+\.){3}[0-9]+"
}

recovery_camera() {
  ioc_name=$1

  ip=$(get_ip $ioc_name)

  echo "Stopping '$ioc_name'..."
  iocs stop $ioc_name

  if [ -z "$(arv-tool-0.8 -a $ip 2> /dev/null)" ]; then
    echo "Camera not found in the subnetwork."

    exit 2
  fi

  echo "Resetting camera '$ip'..."
  # keep trying until we get the write access
  while ! arv-tool-0.8 -a $ip control DeviceReset | grep -qF "DeviceReset executed"; do
    echo "Write access not available yet. Trying again in 10 seconds..."
    sleep 10
  done

  echo "Reconfiguring camera..."
  while ! arv-tool-0.8 -a $ip control GevSCPSPacketSize=1500 | grep -qE '^GevSCPSPacketSize'; do
    echo "Camera not yet available in the network after reset. Trying again in 5 seconds..."
    sleep 5
  done

  echo "Testing camera for 10 seconds..."
  arv-camera-test-0.8 -n $ip -f 7 --h-binning=2 --v-binning=2 --duration 10

  echo "Restarting '$ioc_name'..."
  iocs start $ioc_name
}

for ioc; do
  recovery_camera $ioc
done
