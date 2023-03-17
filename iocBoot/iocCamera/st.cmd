#!../../bin/linux-x86_64/Camera

#- You may have to change Camera to something else
#- everywhere it appears in this file

#< envPaths

## Register all support components
dbLoadDatabase "../../dbd/Camera.dbd"
Camera_registerRecordDeviceDriver(pdbbase) 

## Load record instances
#dbLoadRecords("../../db/Camera.db","user=root")

iocInit()

## Start any sequence programs
#seq sncCamera,"user=root"
