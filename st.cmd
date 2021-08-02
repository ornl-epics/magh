#!../../bin/linux-x86_64/MagH

## You may have to change MagH to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/MagH.dbd"
MagH_registerRecordDeviceDriver pdbbase

# Define protocol path
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(CRYOMAGNETICS)/protocol/")
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(STREAM_PROTOCOL_PATH):$(MAGH)/protocol/")
epicsEnvSet("STREAM_PROTOCOL_PATH", "$(STREAM_PROTOCOL_PATH):$(TEMPMON612)/protocol/")


drvAsynIPPortConfigure ("Magnet1","10.112.45.128:4444",0,0,0)
drvAsynIPPortConfigure ("tm1","10.112.45.129:4001",0,0,0)



#This prints low level commands and responses
asynSetTraceMask("Magnet1",0,0x07)
asynSetTraceIOMask("Magnet1",0,0x07)



dbLoadRecords("db/Magnet.db")



#################################################
# autosave

epicsEnvSet IOCNAME secage-SE-MagH
epicsEnvSet SAVE_DIR /home/controls/var/$(IOCNAME)

save_restoreSet_Debug(0)

### status-PV prefix, so save_restore can find its status PV's.
save_restoreSet_status_prefix("SE:CS:MagH:")

set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")

save_restoreSet_NumSeqFiles(3)
save_restoreSet_SeqPeriodInSeconds(600)
set_pass0_restoreFile("$(IOCNAME).sav")
set_pass0_restoreFile("$(IOCNAME)_pass0.sav")
set_pass1_restoreFile("$(IOCNAME).sav")

#################################################


cd "${TOP}/iocBoot/${IOC}"
iocInit
#This prints low level commands and responses
asynSetTraceMask("Magnet1",0,0x07)
asynSetTraceIOMask("Magnet1",0,0x07)



# Create request file and start periodic 'save'
epicsThreadSleep(5)
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME).req", "autosaveFields")
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME)_pass0.req", "autosaveFields_pass0")
create_monitor_set("$(IOCNAME).req", 5)
create_monitor_set("$(IOCNAME)_pass0.req", 30)

                               

