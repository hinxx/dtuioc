< envPaths
errlogInit(20000)

dbLoadDatabase("$(TOP)/dbd/dtuApp.dbd")
dtuApp_registerRecordDeviceDriver(pdbbase) 

# The search path for ADCore database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "10000000")

################################################################################
## Allied Vision Manta G235B
################################################################################

epicsEnvSet("PREFIX", "13ARV1:")
epicsEnvSet("PORT",   "ARV1")
epicsEnvSet("QSIZE",  "20")
epicsEnvSet("XSIZE",  "1936")
epicsEnvSet("YSIZE",  "1216")
epicsEnvSet("NCHANS", "2048")
epicsEnvSet("CBUFFS", "500")

aravisCameraConfig("$(PORT)", "Allied Vision Technologies-50-0503355057")

# asynSetTraceMask("$(PORT)", 0, 0x21)
dbLoadRecords("$(ADARAVIS)/db/aravisCamera.template", "P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")
dbLoadRecords("$(ADARAVIS)/db/AVT_Manta_G235B.template","P=$(PREFIX),R=cam1:,PORT=$(PORT),ADDR=0,TIMEOUT=1")

# Create a standard arrays plugin
NDStdArraysConfigure("Image1", 5, 0, "$(PORT)", 0, 0)
# Allow for cameras up to 1936x1216x3 for RGB
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(PREFIX),R=image1:,PORT=Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),TYPE=Int16,FTVL=SHORT,NELEMENTS=7062528")

# Load all other plugins using commonPlugins.cmd
< $(TOP)/iocBoot/$(IOC)/commonPlugins.cmd

#set_requestfile_path("$(ADARAVIS)/prosilicaApp/Db")

#asynSetTraceMask("$(PORT)",0,255)
#asynSetTraceMask("$(PORT)",0,3)


################################################################################
## Thorlabs CCS200
################################################################################

# Resource string: USB::VID::PID::SERIAL::RAW
epicsEnvSet("RSCSTR", "USB::0x1313::0x8089::M00414547::RAW")

epicsEnvSet("PREFIX", "CCS1:")
epicsEnvSet("PORT",   "CCS1")
epicsEnvSet("CAM",    "cam1:")
epicsEnvSet("QSIZE",  "20")
epicsEnvSet("XSIZE",  "3648")
epicsEnvSet("YSIZE",  "1")
epicsEnvSet("NCHANS", "2048")

# Create a Thorlabs CCSxxx driver
# tlCCSConfig(const char *portName, int maxBuffers, size_t maxMemory, 
#             const char *resourceName, int priority, int stackSize)
tlCCSConfig("$(PORT)", 0, 0, "$(RSCSTR)", 0, 100000)
dbLoadRecords("$(ADTLCCS)/tlccsApp/Db/tlccs.template",  "P=$(PREFIX),R=$(CAM),PORT=$(PORT),ADDR=0,TIMEOUT=1,NELEMENTS=$(XSIZE)")

# Create ASCII file saving plugin
#NDFileAsciiConfigure("Ascii1", $(QSIZE), 0, "$(PORT)", 0)
#dbLoadRecords("$(ADMISC)/db/NDFileAscii.template", "P=$(PREFIX),R=Ascii1:,PORT=Ascii1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")

# Create standard arrays plugin for a trace
#NDStdArraysConfigure("TRACE1", 5, 0, "$(PORT)", 0, 0)
#dbLoadRecords("$(ADCORE)/ADApp/Db/NDStdArrays.template", "P=$(PREFIX),R=Trace1:,PORT=TRACE1,ADDR=0,TIMEOUT=1,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=4000,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0")


## Load all other plugins using commonPlugins.cmd
< $(TOP)/iocBoot/$(IOC)/commonPlugins.cmd

#set_requestfile_path("$(TLCCS)/tlccsApp/Db")
#set_requestfile_path("$(ADFILEASCII)/adfileasciiApp/Db")

#asynSetTraceIOMask("$(PORT)",0,2)
#asynSetTraceMask("$(PORT)",0,255)



iocInit()

# save things every thirty seconds
create_monitor_set("auto_settings.req", 30,"P=$(PREFIX)")
