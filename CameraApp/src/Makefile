TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = Camera
DBD += Camera.dbd

Camera_DBD += ADAravisSupport.dbd
Camera_LIBS += ADAravis

Camera_SRCS += Camera_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
Camera_SRCS_DEFAULT += CameraMain.cpp
Camera_SRCS_vxWorks += -nil-

# Load libraries from common areaDetector plugins
DBD_NAME = $(PROD_IOC)
include $(ADCORE)/ADApp/commonDriverMakefile

# Finally link to the EPICS Base libraries
Camera_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
