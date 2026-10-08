#!/opt/ad-aravis-epics-ioc/bin/linux-x86_64/Camera

cd /opt/ad-aravis-epics-ioc/iocBoot/iocCamera

< envPaths

# IOC and device specific configuration
< device.cmd

# Configure Area Detector plugins
< plugins.cmd

# Restrict camera features
< limits.cmd

iocInit()

< post-init.cmd
