TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = Camera
# Camera.dbd will be created and installed
DBD += Camera.dbd

# Camera.dbd will be made up from these files:
Camera_DBD += base.dbd

# Include dbd files from all support applications:
#Camera_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
#Camera_LIBS += xxx

# Camera_registerRecordDeviceDriver.cpp derives from Camera.dbd
Camera_SRCS += Camera_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
Camera_SRCS_DEFAULT += CameraMain.cpp
Camera_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#Camera_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
Camera_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

