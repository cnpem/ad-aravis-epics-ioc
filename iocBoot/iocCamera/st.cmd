#!/opt/ad-aravis-epics-ioc/bin/linux-x86_64/Camera
# -*- container-image: ghcr.io/cnpem/ad-aravis-epics-ioc

cd /opt/ad-aravis-epics-ioc/iocBoot/iocCamera

< envPaths

# IOC and device specific configuration
epicsEnvSet("PREFIX", "BL:H:BASLER01:")
epicsEnvSet("IP_ADDRESS", "10.128.2.11")
epicsEnvSet("DEVICE_MANUFACTURER", "Basler")
epicsEnvSet("DEVICE_MODEL", "acA1300-75gm")
epicsEnvSet("DEVICE_VERSION", "106755-13")

< device.cmd

# Configure Area Detector plugins
epicsEnvSet("MAX_IMAGE_WIDTH", 1280)
epicsEnvSet("MAX_IMAGE_HEIGHT", 1024)
epicsEnvSet("MAX_IMAGE_PIXELS", 1310720)
epicsEnvSet("QSIZE", 20)
epicsEnvSet("QSIZE_HDF5", 50)

< plugins.cmd

# Restrict camera features
epicsEnvSet("ACQUIRE_PERIOD_LOW_LIMIT", 0.1)

< limits.cmd

< autosave.cmd

iocInit()

< post-init.cmd
