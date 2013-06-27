#!/bin/bash

SCALER="SR08ID01:scaler1"
COUNTTIME="100" # counting time guaranteed to be higher than longest exposure
SHOTMODE="OneShot"


# Stop counting if it was
if [ "$(caget -t ${SCALER}.CNT)" != "Done "  ] ; then
	caput ${SCALER}.CNT "Done"  > /dev/null
	usleep 100000
fi

# Set counting time if needed
if [ "$(caget -t ${SCALER}.TP)" != "${COUNTTIME} "  ] ; then
	caput ${SCALER}.TP ${COUNTTIME}  > /dev/null
	usleep 100000
fi

# Set single shot if needed
if [ "$(caget -t ${SCALER}.CONT)" != "${SHOTMODE} "  ] ; then
	caput ${SCALER}.CONT ${SHOTMODE}  > /dev/null
	usleep 100000
fi

# start counting
caput ${SCALER}.CNT "Count" > /dev/null
usleep 100000
