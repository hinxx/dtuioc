< envPaths
errlogInit(20000)

dbLoadDatabase("$(TOP)/dbd/dtuApp.dbd")
dtuApp_registerRecordDeviceDriver(pdbbase) 

# The search path for ADCore database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "30000000")

################################################################################
## Allied Vision Manta G235B
################################################################################

epicsEnvSet("PREFIX", "CAM1:")
epicsEnvSet("PORT",   "CAM1")
epicsEnvSet("QSIZE",  "20")
epicsEnvSet("XSIZE",  "1936")
epicsEnvSet("YSIZE",  "1216")
epicsEnvSet("NCHANS", "2048")
epicsEnvSet("CBUFFS", "500")

aravisCameraConfig("$(PORT)", "Allied Vision Technologies-50-0503355057")

# asynSetTraceMask("$(PORT)", 0, 0x21)
dbLoadRecords("$(ADARAVIS)/db/aravisCamera.template",   "P=$(PREFIX),R=det1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADARAVIS)/db/AVT_Manta_G235B.template","P=$(PREFIX),R=det1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")

# Create a standard arrays plugin
# Allow for images up to 1936x1216x3 for RGB
NDStdArraysConfigure("$(PORT)Image1", 5, 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=$(PORT)Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int16,FTVL=SHORT,NELEMENTS=7062528")
NDStdArraysConfigure("$(PORT)Image2", 5, 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image2:,PORT=$(PORT)Image2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int16,FTVL=SHORT,NELEMENTS=7062528")
NDStdArraysConfigure("$(PORT)Image3", 5, 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image3:,PORT=$(PORT)Image3,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int16,FTVL=SHORT,NELEMENTS=7062528")

# Load all other plugins using commonPlugins.cmd
< $(TOP)/iocBoot/$(IOC)/commonPlugins.cmd

#set_requestfile_path("$(ADARAVIS)/aravisGigEApp/Db")

#asynSetTraceMask("$(PORT)",0,255)
#asynSetTraceMask("$(PORT)",0,3)


################################################################################
## Thorlabs CCS200
################################################################################

# Resource string: USB::VID::PID::SERIAL::RAW
#epicsEnvSet("RSCSTR", "USB::0x1313::0x8089::M00414547::RAW")
epicsEnvSet("RSCSTR", "USB::0x1313::0x8089::M00407309::RAW")

epicsEnvSet("PREFIX", "CCS1:")
epicsEnvSet("PORT",   "CCS1")
epicsEnvSet("QSIZE",  "20")
epicsEnvSet("XSIZE",  "3648")
epicsEnvSet("YSIZE",  "1")
epicsEnvSet("NCHANS", "2048")
epicsEnvSet("CBUFFS", "500")

# Create a Thorlabs CCSxxx driver
# tlCCSConfig(const char *portName, int maxBuffers, size_t maxMemory, 
#             const char *resourceName, int priority, int stackSize)
tlCCSConfig("$(PORT)", 0, 0, "$(RSCSTR)", 0, 0)
dbLoadRecords("$(ADTLCCS)/tlccsApp/Db/tlccs.template", "P=$(PREFIX),R=det1:,PORT=$(PORT),ADDR=0,TIMEOUT=1,NELEMENTS=$(XSIZE)")

# Create standard arrays plugin for a trace
NDStdArraysConfigure("$(PORT)Trace1", $(QSIZE), 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=trace1:,PORT=$(PORT)Trace1,ADDR=0,TIMEOUT=1,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=4000,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")
NDStdArraysConfigure("$(PORT)Trace2", $(QSIZE), 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=trace2:,PORT=$(PORT)Trace2,ADDR=0,TIMEOUT=1,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=4000,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")
NDStdArraysConfigure("$(PORT)Trace3", $(QSIZE), 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=trace3:,PORT=$(PORT)Trace3,ADDR=0,TIMEOUT=1,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=4000,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")

## Load all other plugins using commonPlugins.cmd
< $(TOP)/iocBoot/$(IOC)/commonPlugins.cmd

#set_requestfile_path("$(ADTLCCS)/tlccsApp/Db")

#asynSetTraceIOMask("$(PORT)",0,2)
#asynSetTraceMask("$(PORT)",0,255)

################################################################################
## Thorlabs CCS100
################################################################################

# Resource string: USB::VID::PID::SERIAL::RAW
epicsEnvSet("RSCSTR", "USB::0x1313::0x8081::M00310589::RAW")

epicsEnvSet("PREFIX", "CCS2:")
epicsEnvSet("PORT",   "CCS2")
epicsEnvSet("QSIZE",  "20")
epicsEnvSet("XSIZE",  "3648")
epicsEnvSet("YSIZE",  "1")
epicsEnvSet("NCHANS", "2048")
epicsEnvSet("CBUFFS", "500")

# Create a Thorlabs CCSxxx driver
# tlCCSConfig(const char *portName, int maxBuffers, size_t maxMemory, 
#             const char *resourceName, int priority, int stackSize)
tlCCSConfig("$(PORT)", 0, 0, "$(RSCSTR)", 0, 0)
dbLoadRecords("$(ADTLCCS)/tlccsApp/Db/tlccs.template", "P=$(PREFIX),R=det1:,PORT=$(PORT),ADDR=0,TIMEOUT=1,NELEMENTS=$(XSIZE)")

# Create standard arrays plugin for a trace
NDStdArraysConfigure("$(PORT)Trace1", $(QSIZE), 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=trace1:,PORT=$(PORT)Trace1,ADDR=0,TIMEOUT=1,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=4000,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")
NDStdArraysConfigure("$(PORT)Trace2", $(QSIZE), 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=trace2:,PORT=$(PORT)Trace2,ADDR=0,TIMEOUT=1,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=4000,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")
NDStdArraysConfigure("$(PORT)Trace3", $(QSIZE), 0, "$(PORT)", 0, 0)
dbLoadRecords("$(ADCORE)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=trace3:,PORT=$(PORT)Trace3,ADDR=0,TIMEOUT=1,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=4000,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")


## Load all other plugins using commonPlugins.cmd
< $(TOP)/iocBoot/$(IOC)/commonPlugins.cmd

#set_requestfile_path("$(ADTLCCS)/tlccsApp/Db")

#asynSetTraceIOMask("$(PORT)",0,2)
#asynSetTraceMask("$(PORT)",0,255)

dbLoadRecords("$(TOP)/db/dtu.db", "P=DTU:,R=")

iocInit()

# save things every thirty seconds
#create_monitor_set("cam_auto_settings.req", 30,"P=$(PREFIX)")
#create_monitor_set("ccs_auto_settings.req", 30,"P=$(PREFIX)")