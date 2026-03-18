#!/opt/epics-R3.15.9/modules/StreamDevice-2.8.16/bin/linux-x86_64/streamApp

# Setting environment variables
epicsEnvSet("IOC",                      "/home/ABTLUS/leonardo.leao/apps/streakcamera-epics-ioc/ioc")
epicsEnvSet("STREAMDEVICE",             "/opt/epics-R3.15.9/modules/StreamDevice-2.8.16")
epicsEnvSet("STREAM_PROTOCOL_PATH",     "${IOC}/protocol")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "1048576")

# Setting up streamdevice
dbLoadDatabase("${STREAMDEVICE}/dbd/streamApp.dbd")
streamApp_registerRecordDeviceDriver(pdbbase)

# Setting up TCP/IP
drvAsynIPPortConfigure("PS1", "10.31.24.28:1001")
#drvAsynIPPortConfigure("PS2", "10.31.24.28:1002")

# Load the records of Edwards Vacuum
dbLoadRecords("${IOC}/db/StreakCamera.db", "port = PS1")

# Initialize the IOC
cd "${IOC}/iocBoot"
iocInit

