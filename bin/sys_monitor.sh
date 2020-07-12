#!/bin/bash
# Name :- Pushkar Madan
# Email :- pushkarmadan@yahoo.com
# Date :- 11th July 2020
# Purpose :- To Generate and configure system folders and path for installing scripts and directories to store logs.
# Milestone :- None
# Last Modified :- 12th July 2020
# Reason To Modify :- Creation.
# Notes :-

### Variables.
TODAY=$(date +"%Y-%m-%d")
LOG_DIR="/home/system_monitor/data"
TS=$(date +"%H-%M")
MEM_FILE=${LOG_DIR}/${TODAY}/${TS}-mem
PROC_FILE=${LOG_DIR}/${TODAY}/${TS}-proc
TOP_FILE=${LOG_DIR}/${TODAY}/${TS}-top
IOSTAT_FILE=${LOG_DIR}/${TODAY}/${TS}-iostat
NET_FILE=${LOG_DIR}/${TODAY}/${TS}-net

### Variables for Cleanup Functions.
BACKLOG=14 ### Keep backlogs for previous for last 14 days (2 weeks).


### misc Variables for formatting.
SMALL_LINE="------------------------------------------------------------------------------"
MED_LINE="=============================================================================="
BIG_LINE="##############################################################################"

### Functions.
CREATE_LOG_DIR(){
	if [ ! -d "${LOG_DIR}/${TODAY}" ];then
		mkdir -p ${LOG_DIR}/${TODAY}
	fi
}

### combined free and vmstat together can be seperated later. 
MEMORY(){
	free
	echo -e "\n${SMALL_LINE}\n"
	cat /proc/vmstat
}

PROCESS(){
	ps auxwf
}

TOP(){
	top -b -1 -w 512 -n1
}

IOSTAT(){
	iostat -xdNk
}

NET(){
	ss -aenpO
}

CLEANUP(){
	find ${LOG_DIR}	-type d -mtime +${BACKLOG} -exec rm -rf {} \;
}

MAIN(){
	CREATE_LOG_DIR

	MEMORY > ${MEM_FILE} 2>&1 &

	PROCESS > ${PROC_FILE} 2>&1 & 

	TOP > ${TOP_FILE} 2>&1 &
	
	IOSTAT > ${IOSTAT_FILE} 2>&1 &

	NET > ${NET_FILE} 2>&1 &

	wait

	sleep 10
}

### Main

MAIN

