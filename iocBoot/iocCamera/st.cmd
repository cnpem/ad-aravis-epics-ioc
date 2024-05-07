#!/usr/bin/env Camera
# -*- container-image: ghcr.io/cnpem/ad-aravis-epics-ioc

< /usr/local/share/misc/envPaths
epicsEnvSet("IOC_CONFIG", "$(TOP)/iocBoot/$(IOC)")

# IOC and device specific configuration
epicsEnvSet("PREFIX", "BL:H:BASLER01:")
epicsEnvSet("IP_ADDRESS", "10.128.2.11")
epicsEnvSet("DEVICE_MANUFACTURER", "Basler")
epicsEnvSet("DEVICE_MODEL", "acA1300-75gm")
epicsEnvSet("DEVICE_VERSION", "106755-13")

< $(IOC_CONFIG)/device.cmd

# Configure Area Detector plugins
epicsEnvSet("MAX_IMAGE_WIDTH", 1280)
epicsEnvSet("MAX_IMAGE_HEIGHT", 1024)
epicsEnvSet("MAX_IMAGE_PIXELS", 1310720)

< $(IOC_CONFIG)/plugins.cmd

# Restrict camera features
epicsEnvSet("ACQUIRE_PERIOD_LOW_LIMIT", 0.1)

< $(IOC_CONFIG)/limits.cmd

< $(IOC_CONFIG)/autosave.cmd

iocInit()

< $(IOC_CONFIG)/post-init.cmd
