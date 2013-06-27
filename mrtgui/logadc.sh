#!/bin/bash

CH1="keithley:unit2Measure"
CH2="keithley:unit4Measure"
RC="SR11BCM01:CURRENT_MONITOR"
#timestamp
echo -n $(date +"%F_%T.%N") " " | tee -a "$1"
echo -n ,$(caget -t ${CH1} ${CH2} ${RC}) | tee -a "$1"
sleep 1
echo -n ,$(caget -t ${CH1} ${CH2} ${RC}) | tee -a "$1"

echo | tee -a "$1"

