#!/bin/bash

CH1="keithley:unit1Measure"
CH2="keithley:unit2Measure"

#timestamp
echo -n $(date +"%F_%T.%N") " " | tee -a "$1"
echo -n $(caget -t ${CH1} ${CH2}) | tee -a "$1"
echo | tee -a "$1"

