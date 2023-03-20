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
# $(DEVICE_MANUFACTURER)
# Camera device manufacturer name.
#
# $(DEVICE_MODEL)
# Camera device model string.
#
# $(DEVICE_VERSION)
# This version differentiates versions from the same model, and allow
# to uniquely identify supported features.

# Register all support components
dbLoadDatabase("${TOP}/dbd/Camera.dbd")
Camera_registerRecordDeviceDriver(pdbbase)

# Define camera driver port
epicsEnvSet("PORT", "CAM")
# Include ADCore to path for loading its databases relatively
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db:$(ADGENICAM)/db")
# Configure automatic CA buffer size
epicsEnvSet("EPICS_CA_AUTO_ARRAY_BYTES", "YES")

# Configure connection to camera
aravisConfig("$(PORT)", "$(IP_ADDRESS)", 0, 0, 0)

# Load device general records from ADAravis
dbLoadRecords("$(ADARAVIS)/db/aravisCamera.template", "P=$(PREFIX), R=cam1:, PORT=$(PORT)")
# Load auto-generated template from camera XML file
dbLoadRecords("$(TOP)/db/$(DEVICE_MANUFACTURER)_$(DEVICE_MODEL)_$(DEVICE_VERSION).db", "P=$(PREFIX), R=cam1:, PORT=$(PORT)")

# Trace error and warning messages
asynSetTraceMask("$(PORT)", 0, ERROR | WARNING)
