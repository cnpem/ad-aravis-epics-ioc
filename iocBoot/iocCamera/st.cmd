#!../../bin/linux-x86_64/Camera

< envPaths

# IOC and device specific configuration
epicsEnvSet("PREFIX", "BL:H:BASLER01:")
epicsEnvSet("IP_ADDRESS", "10.128.2.11")
epicsEnvSet("DEVICE_MANUFACTURER", "Basler")
epicsEnvSet("DEVICE_MODEL", "acA1300-75gm")
epicsEnvSet("DEVICE_VERSION", "106755-13")

< device.cmd

iocInit()
