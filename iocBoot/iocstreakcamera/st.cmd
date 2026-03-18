#!../../bin/linux-x86_64/streakcamera

< envPaths

epicsEnvSet("STREAM_PROTOCOL_PATH", "${TOP}/streakcameraApp/Db")
epicsEnvSet("COMMAND_PORT", "SC_Comm")
epicsEnvSet("DATA_PORT", "SC_Data")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "10000000")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/streakcamera.dbd"
streakcamera_registerRecordDeviceDriver pdbbase

# Setting up TCP/IP
drvAsynIPPortConfigure("$(COMMAND_PORT)", "$(IP_ADDR):$(COMMANDS_TCP) TCP",0,0,0)
drvAsynIPPortConfigure("$(DATA_PORT)", "$(IP_ADDR):$(DATA_TCP) TCP",0,0,0)

## Load record instances
cd "${TOP}/streakcameraApp/Db"
dbLoadRecords("operation.db", "DEVICE=${PREFIX}, CPORT=${COMMAND_PORT}, DPORT=${DATA_PORT}")
dbLoadRecords("gen_params.db", "DEVICE=${PREFIX}, CPORT=${COMMAND_PORT}, DPORT=${DATA_PORT}")
dbLoadRecords("img_params.db", "DEVICE=${PREFIX}, CPORT=${COMMAND_PORT}, DPORT=${DATA_PORT}")
dbLoadRecords("ioc_control.db", "DEVICE=${PREFIX}")

cd "${TOP}/iocBoot/${IOC}" 
iocInit
