# Standard configuration for GenICam cameras based on ADAravis.
#
# Configuration parameters:
#
# $(PREFIX)
# Prefix for all PVs.
#
# $(IP_ADDRESS)
# Camera device IP address.
#
# Optional:
#
# $(ARV_REGISTER_CACHING), default 1
# Enable register caching in Aravis library. Some cameras have unreliable
# metadata regarding cache and might require have it disabled.

# Register all support components
dbLoadDatabase("${TOP}/dbd/Camera.dbd")
Camera_registerRecordDeviceDriver(pdbbase)

# Generate camera-specific GenICam database
system("./generate-camera-db.sh $(IP_ADDRESS) $(TOP) $(ADGENICAM)")

# Define camera driver port
epicsEnvSet("PORT", "CAM")
# Include ADCore to path for loading its databases relatively
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db:$(ADGENICAM)/db")
# Configure automatic CA buffer size
epicsEnvSet("EPICS_CA_AUTO_ARRAY_BYTES", "YES")

# Configure connection to camera
aravisConfig("$(PORT)", "$(IP_ADDRESS)", "$(ARV_REGISTER_CACHING=1)", 0, 0)

# Load device general records from ADAravis
dbLoadRecords("$(ADARAVIS)/db/aravisCamera.template", "P=$(PREFIX), R=cam1:, PORT=$(PORT)")
# Load auto-generated template from camera XML file
dbLoadRecords("$(TOP)/db/device.db", "P=$(PREFIX), R=cam1:, PORT=$(PORT)")

# Load autosave monitoring records
dbLoadRecords("$(AUTOSAVE)/asApp/Db/save_restoreStatus.db", "P=$(PREFIX)")

# Trace error and warning messages
asynSetTraceMask("$(PORT)", 0, ERROR | WARNING)

# Use larger callback queue to account for the high number of PVs
callbackSetQueueSize(5000)

# Configure autosave
< autosave.cmd
