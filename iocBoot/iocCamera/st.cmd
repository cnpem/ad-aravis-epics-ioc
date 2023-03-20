#!../../bin/linux-x86_64/Camera

< envPaths

# IOC and device specific configuration
epicsEnvSet("PREFIX", "BL:H:BASLER01:")
epicsEnvSet("IP_ADDRESS", "10.128.2.11")

< device.cmd

iocInit()
