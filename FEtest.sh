#!/bin/bash

TIMESTAMP=$(date +%Y_%m_%d__%H_%M_%S)

TimeScanMX \
	-m 1.0e-9 -M 1.0e-05 -i 0.5 -p 1200 \
	-d /home/ics/Desktop/Scandata/ -f "vacuum__$TIMESTAMP.dat" \
	-cslg --collapse \
	SR08ID01CCG01:PRESSURE_MONITOR SR08FE01CCG02:PRESSURE_MONITOR SR08FE01CCG03:PRESSURE_MONITOR \
\
& \ 
\
TimeScanMX \
	-m 0.0 -M 100 -i 0.5 -p 1200 \
	-d /home/ics/Desktop/Scandata/ -f "temperature__$TIMESTAMP.dat"  \
	-csg --collapse \
	SR08FE01TES02:TEMPERATURE_MONITOR SR08FE01TES03:TEMPERATURE_MONITOR SR08FE01TES04:TEMPERATURE_MONITOR \
&
