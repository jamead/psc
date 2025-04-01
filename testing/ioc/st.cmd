#!//home/mead/epics/pscdrv/bin/linux-x86_64/pscdemo 
epicsEnvSet("TOP","/home/mead/epics/pscdrv")
epicsEnvSet("PSCDIR","$(TOP)")
epicsEnvSet("PSC_DBDIR","/home/mead/chiesa/psc/testing/ioc")


#epicsEnvSet("CNO","40")   ## Cell Number
#epicsEnvSet("HOSTNAME","diagioc-c$(CNO)")

epicsEnvSet("IOCNAME", "lab")
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
dbLoadRecords("$(PSC_DBDIR)/status10hz.db", "P=$(IOCNAME), NO=1")

dbLoadRecords("$(PSC_DBDIR)/control.db", "P=$(IOCNAME), NO=1")

dbLoadRecords("$(PSC_DBDIR)/snapshot.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/fault_ch1.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/fault_ch2.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/fault_ch3.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")
dbLoadRecords("$(PSC_DBDIR)/fault_ch4.db", "P=$(IOCNAME), NO=1, BUF_LEN=$(BLEN)")

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

#epicsThreadSleep 1

#dbpf $(IOCNAME){BPM:1}Gain:Adc0-SP, 32767
#dbpf $(IOCNAME){BPM:1}Gain:Adc1-SP, 32767
#dbpf $(IOCNAME){BPM:1}Gain:Adc2-SP, 32767
#dbpf $(IOCNAME){BPM:1}Gain:Adc3-SP, 32767

#dbpf $(IOCNAME){BPM:1}Gain:RfAtte-SP, 0 






