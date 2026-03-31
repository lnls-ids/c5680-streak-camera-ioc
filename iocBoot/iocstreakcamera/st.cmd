#!../../bin/linux-x86_64/streakcamera

< envPaths

epicsEnvSet("IOCNAME", "StreakCamera-5680")
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
dbLoadTemplate("c5680.substitutions", "DEVICE=${PREFIX}, CPORT=${COMMAND_PORT}, DPORT=${DATA_PORT}")

cd "${TOP}/iocBoot/${IOC}" 

## Configure autosave
< save_restore.cmd

iocInit

create_monitor_set("sc5680.req", 30, "P=${PREFIX}")
set_savefile_name("sc5680.req", "${IOCNAME}.sav")
