#!/bin/bash

set -e

IP_ADDRESS="$1"
TOP="$2"
ADGENICAM="$3"

echo "Downloading GenICam XML from ${IP_ADDRESS}..."

arv-tool-0.8 -a "${IP_ADDRESS}" genicam > "${TOP}/xml/device.xml"

echo "Generating EPICS database..."

python3 "${ADGENICAM}/scripts/makeDb.py" --devInt64 "${TOP}/xml/device.xml" "${TOP}/db/device.db"

echo "Database generated"
