#!/opt/ad-aravis-epics-ioc/bin/linux-x86_64/Camera
#
# All environment variables required to use this startup script must be
# exported before executing it.
#
# See the documentation in the corresponding iocsh templates included below to
# know which variables are expected by each of them.

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
