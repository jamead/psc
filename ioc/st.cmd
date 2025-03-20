#!//home/mead/epics/pscdrv/bin/linux-x86_64/pscdemo 
epicsEnvSet("TOP","/home/mead/epics/pscdrv")
epicsEnvSet("PSCDIR","$(TOP)")
epicsEnvSet("PSC_DBDIR","/home/mead/chiesa/psc/ioc")


#epicsEnvSet("CNO","40")   ## Cell Number
#epicsEnvSet("HOSTNAME","diagioc-c$(CNO)")
epicsEnvSet("IOCNAME", "LN-BI")



###
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "YES")
#epicsEnvSet("EPICS_CA_ADDR_LIST", "10.0.142.20")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "16000000")


## You may have to change psc to something else
## everywhere it appears in this file

## Register all support components
dbLoadDatabase("$(PSCDIR)/dbd/pscdemo.dbd",0,0)
pscdemo_registerRecordDeviceDriver(pdbbase) 

# BPM IP address
epicsEnvSet("PSC1_IP", "10.0.142.43");  #4009


## Load record instances
epicsEnvSet("ALIVELEN", "8000");   # ADC Live length
epicsEnvSet("TLIVELEN", "8000");   # ADC Live length
epicsEnvSet("ALEN",1000000);        # ADC DMA Length
epicsEnvSet("TLEN", "100000");      # TbT Length

########## use template

### PVs for first LINAC ZBPM:
dbLoadRecords("$(PSC_DBDIR)/adc10hz.db", "P=$(IOCNAME), NO=1")

#####################################################
var(PSCDebug, 5)	#5 full debug

#bpm1 Create the PSC
createPSC("aie_tx_1", $(PSC1_IP), 7, 0)
#createPSC("aie_wfm_rx_1", $(PSC1_IP), 20, 2)
createPSC("Rx1", $(PSC1_IP), 600, 2)

###########
iocInit
###########

#epicsThreadSleep 1

#dbpf $(IOCNAME){BPM:1}Gain:Adc0-SP, 32767
#dbpf $(IOCNAME){BPM:1}Gain:Adc1-SP, 32767
#dbpf $(IOCNAME){BPM:1}Gain:Adc2-SP, 32767
#dbpf $(IOCNAME){BPM:1}Gain:Adc3-SP, 32767

#dbpf $(IOCNAME){BPM:1}Gain:RfAtte-SP, 0 






