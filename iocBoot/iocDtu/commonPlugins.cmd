# This is an example file for creating plugins
# It uses the following environment variable macros
# Many of the parameters defined in this file are also in commonPlugins_settings.req so if autosave is being
# use the autosave value will replace the value passed to this file.

# $(PREFIX)      Prefix for all records
# $(PORT)        The port name for the detector.  In autosave.
# $(QSIZE)       The queue size for all plugins.  In autosave.
# $(XSIZE)       The maximum image width; used to set the maximum size for row profiles in the NDPluginStats plugin and 1-D FFT
#                   profiles in NDPluginFFT.
# $(YSIZE)       The maximum image height; used to set the maximum size for column profiles in the NDPluginStats plugin
# $(NCHANS)      The maximum number of time series points in the NDPluginStats, NDPluginROIStats, and NDPluginAttribute plugins
# $(CBUFFS)      The maximum number of frames buffered in the NDPluginCircularBuff plugin
# $(MAX_THREADS) The maximum number of threads for plugins which can run in multiple threads. Defaults to 5.

# Create an HDF5 file saving plugin
NDFileHDF5Configure("$(PORT)FileHDF1", $(QSIZE), 0, "$(PORT)", 0)
dbLoadRecords("NDFileHDF5.template",  "P=$(PREFIX),R=HDF1:,PORT=$(PORT)FileHDF1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create 4 ROI plugins
NDROIConfigure("$(PORT)ROI1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI1:,  PORT=$(PORT)ROI1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDROIConfigure("$(PORT)ROI2", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI2:,  PORT=$(PORT)ROI2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDROIConfigure("$(PORT)ROI3", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI3:,  PORT=$(PORT)ROI3,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDROIConfigure("$(PORT)ROI4", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template",       "P=$(PREFIX),R=ROI4:,  PORT=$(PORT)ROI4,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create 2 processing plugins
NDProcessConfigure("$(PORT)PROC1", $(QSIZE), 0, "$(PORT)", 0, 0, 0)
dbLoadRecords("NDProcess.template",   "P=$(PREFIX),R=Proc1:,  PORT=$(PORT)PROC1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")
NDProcessConfigure("$(PORT)PROC2", $(QSIZE), 0, "$(PORT)", 0, 0, 0)
dbLoadRecords("NDProcess.template",   "P=$(PREFIX),R=Proc2:,  PORT=$(PORT)PROC2,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)")

# Create 2 statistics plugins
NDStatsConfigure("$(PORT)STATS1", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",     "P=$(PREFIX),R=Stats1:,  PORT=$(PORT)STATS1,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")
NDStatsConfigure("$(PORT)STATS2", $(QSIZE), 0, "ROI1",    0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template",     "P=$(PREFIX),R=Stats2:,  PORT=$(PORT)STATS2,ADDR=0,TIMEOUT=1,HIST_SIZE=256,XSIZE=$(XSIZE),YSIZE=$(YSIZE),NCHANS=$(NCHANS),NDARRAY_PORT=$(PORT)")

#set_requestfile_path("./")
#set_requestfile_path("$(ADCORE)/ADApp/Db")
#set_requestfile_path("$(ADCORE)/iocBoot")
#set_savefile_path("./autosave")
#set_pass0_restoreFile("auto_settings.sav")
#set_pass1_restoreFile("auto_settings.sav")
#save_restoreSet_status_prefix("$(PREFIX)")
#dbLoadRecords("$(AUTOSAVE)/asApp/Db/save_restoreStatus.db", "P=$(PREFIX)")
