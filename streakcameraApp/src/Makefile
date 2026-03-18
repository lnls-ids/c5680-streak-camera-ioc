# SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#
# SPDX-License-Identifier: EPICS

TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = streakcamera
# streakcamera.dbd will be created and installed
DBD += streakcamera.dbd

# streakcamera.dbd will be made up from these files:
streakcamera_DBD += base.dbd

# Include dbd files from all support applications:
#streakcamera_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
#streakcamera_LIBS += xxx

# streakcamera_registerRecordDeviceDriver.cpp derives from streakcamera.dbd
streakcamera_SRCS += streakcamera_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
streakcamera_SRCS_DEFAULT += streakcameraMain.cpp
streakcamera_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#streakcamera_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
streakcamera_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

streakcamera_DBD += stream.dbd
streakcamera_DBD += asyn.dbd
streakcamera_DBD += drvAsynIPPort.dbd
streakcamera_DBD += calcSupport.dbd

streakcamera_LIBS += stream
streakcamera_LIBS += asyn 
streakcamera_LIBS += calc 
