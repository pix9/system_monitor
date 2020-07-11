#!/bin/bash
# Name :- Pushkar Madan
# Email :- pushkarmadan@yahoo.com
# Date :- 11th July 2020
# Purpose :- To Generate and configure system folders and path for installing scripts and directories to store logs.
# Milestone :- None
# Last Modified :- 11th July 2020
# Reason To Modify :- Creation.
# Notes :-

### Variables.
TODAY=$(date +"%Y-%m-%d")
LOG_DIR=/home/SYSTEM_MONITOR/${TODAY}
TS=$(date +"%H-%M")
MEM_FILE=${LOG_DIR}/${TS}-mem
PROC_FILE=${LOG_DIR}/${TS}-proc
TOP_FILE=${LOG_DIR}/${TS}-top
IOSTAT_FILE=${LOG_DIR}/${TS}-iostat
NET_FILE=${LOG_DIR}/${TS}-net

### misc Variables for formatting.
SMALL_LINE="------------------------------------------------------------------------------"
MED_LINE="=============================================================================="
BIG_LINE="##############################################################################"

### Functions.
CREATE_LOG_DIR(){
	if [ ! -d "${LOG_DIR}" ];then
		mkdir -p ${LOG_DIR}
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

