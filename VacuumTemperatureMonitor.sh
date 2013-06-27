#!/bin/bash

TIMESTAMP=$(date +%Y_%m_%d__%H_%M_%S)

TimeScanMX \
	-m 1.0e-09 -M 1.0e-05 -i 0.5 -p 1200 \
	-d /home/ics/Desktop/Scandata/ -f "vacuum__1_$TIMESTAMP.dat" \
	-cslg --collapse --nostore \
        SR08FE01CCG01:PRESSURE_MONITOR \
        SR08FE01CCG02:PRESSURE_MONITOR \
        SR08FE01CCG03:PRESSURE_MONITOR \
        SR08ID01CCG01:PRESSURE_MONITOR \
        SR08ID01CCG02:PRESSURE_MONITOR \
        SR08ID01CCG03:PRESSURE_MONITOR \
\
& \ 
\

TimeScanMX \
	-m 1.0e-09 -M 1.0e-05 -i 0.5 -p 1200 \
	-d /home/ics/Desktop/Scandata/ -f "vacuum__2_$TIMESTAMP.dat" \
	-cslg --collapse --nostore \
        SR08ID01CCG04:PRESSURE_MONITOR \
        SR08ID01CCG05:PRESSURE_MONITOR \
        SR08ID01PMG01:PRESSURE \
        SR08ID01PMG02:PRESSURE \
        SR08ID01PMG03:PRESSURE \
        SR08ID01PMG04:PRESSURE \
\
& \ 
\

TimeScanMX \
	--automin --automax -i 0.5 -p 1200 \
	-d /home/ics/Desktop/Scandata/ -f "temperature__$TIMESTAMP.dat"  \
	-csg --collapse --nostore \
	SR08FE01TES02:TEMPERATURE_MONITOR  \
	SR08FE01TES03:TEMPERATURE_MONITOR  \
	SR08FE01TES04:TEMPERATURE_MONITOR  \
&



