#!//home/mead/epics/pscdrv/bin/linux-x86_64/pscdemo 
epicsEnvSet("TOP","/home/mead/epics/pscdrv")
epicsEnvSet("PSCDIR","$(TOP)")
epicsEnvSet("PSC_DBDIR","/home/mead/chiesa/psc/testing/ioc")


#epicsEnvSet("CNO","40")   ## Cell Number
#epicsEnvSet("HOSTNAME","diagioc-c$(CNO)")

epicsEnvSet("IOCNAME", "lab")
epicsEnvSet("IOCNUM","1");
epicsEnvSet("CHAN1", "Chan1")
epicsEnvSet("CHAN2", "Chan2")
epicsEnvSet("CHAN3", "Chan3")
epicsEnvSet("CHAN4", "Chan4")







###
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "YES")
#epicsEnvSet("EPICS_CA_ADDR_LIST", "10.0.142.20")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "20000000")


## You may have to change psc to something else
## everywhere it appears in this file

## Register all support components
dbLoadDatabase("$(PSCDIR)/dbd/pscdemo.dbd",0,0)
pscdemo_registerRecordDeviceDriver(pdbbase) 

# BPM IP address
epicsEnvSet("PSC1_IP", "10.0.142.43");  #4009


epicsEnvSet("BLEN",100000);        # Snapshot DMA Length


## Load record instances

### PVs for PSC:
dbLoadRecords("$(PSC_DBDIR)/status10hz.db", "P=$(IOCNAME), NO=1, OFFSET=100")

dbLoadRecords("$(PSC_DBDIR)/control_glob.db", "P=$(IOCNAME), NO=1")
dbLoadRecords("$(PSC_DBDIR)/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=1")
dbLoadRecords("$(PSC_DBDIR)/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=2")
dbLoadRecords("$(PSC_DBDIR)/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=3")
dbLoadRecords("$(PSC_DBDIR)/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=4")




#dbLoadRecords("$(PSC_DBDIR)/snapshot.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")


dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=1, MSGID=60, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=2, MSGID=61, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=3, MSGID=62, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=4, MSGID=63, BUFLEN=$(BLEN)")

dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=1, MSGID=70, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=2, MSGID=71, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=3, MSGID=72, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=4, MSGID=73, BUFLEN=$(BLEN)")

dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=1, MSGID=80, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=2, MSGID=81, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=3, MSGID=82, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=4, MSGID=83, BUFLEN=$(BLEN)")

dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=1, MSGID=90, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=2, MSGID=91, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=3, MSGID=92, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=4, MSGID=93, BUFLEN=$(BLEN)")

dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=1, MSGID=100, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=2, MSGID=101, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=3, MSGID=102, BUFLEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=4, MSGID=103, BUFLEN=$(BLEN)")


#dbLoadRecords("$(PSC_DBDIR)/fault_ch1.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")
#dbLoadRecords("$(PSC_DBDIR)/fault_ch2.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")
#dbLoadRecords("$(PSC_DBDIR)/fault_ch3.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")
#dbLoadRecords("$(PSC_DBDIR)/fault_ch4.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")

dbLoadRecords("$(PSC_DBDIR)/wfmstats.db", "P=$(IOCNAME), PSC=1")




#####################################################
var(PSCDebug, 5)	#5 full debug

#psc1 Create the PSC
createPSC("Tx1", $(PSC1_IP), 7, 0)
createPSC("Wfm1", $(PSC1_IP), 20, 1)
createPSC("Rx1", $(PSC1_IP), 600, 1)

###########
iocInit
###########

epicsThreadSleep 1







