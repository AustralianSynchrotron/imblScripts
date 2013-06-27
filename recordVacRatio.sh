#!/bin/bash

PVBEFORE="SR08FE01CCG02:PRESSURE_MONITOR" 
PVAFTER="SR08FE01CCG03:PRESSURE_MONITOR"
LOGFILE="/home/ics/Desktop/Scandata/presrat_$(date +%Y_%m_%d__%H_%M_%S).dat"

while true ; do
	PRBEFORE=$(caget -t -f 12 $PVBEFORE)
	PRAFTER=$(caget -t -f 12 $PVAFTER)
	DPMP=$(echo "scale=20; 2.0*($PRBEFORE-$PRAFTER)/($PRBEFORE+$PRAFTER)" | bc)
	echo $(date +%Y_%m_%d__%H_%M_%S) $DPMP $PRBEFORE $PRAFTER >> "$LOGFILE"
	echo $(date +%Y_%m_%d__%H_%M_%S) $DPMP $PRBEFORE $PRAFTER
	sleep 1s
done
