#!/bin/bash

MOTOR="SR08ID01MCS03:MTRC"
SHUT="SR08ID01IS01"
LOG="scanthrough.$(date +%Y-%m-%d_%H.%M.%S).log"

log () {
	echo $* $(date +%Y-%m-%d_%H:%M:%S) >> $LOG
	caget keithley:unit2:Measure keithley:unit4:Measure >> $LOG
}


if ! caget -t "${MOTOR}" &> /dev/null ; then
     echo "Error. Motor $MOTOR is not conected."
     exit 1
fi

if ! caget -t "${SHUT}:EXPOSUREPERIOD_MONITOR" &> /dev/null ; then
     echo "Error. Shutter $SHUT is not conected."
     exit 1
fi

if [ -z "$1" ] ; then
    echo "Error. No distance given."
    echo "Usage: $0 <distance> <speed> <repetitions>"
    exit 1
fi

if [ -z "$2" ] ; then
    echo "Error. No speed given."
    echo "Usage: $0 <distance> <speed> <repetitions>"
    exit 1
fi

if [ -z "$3" ] ; then
    echo "Error. No repetitions given."
    echo "Usage: $0 <distance> <speed> <repetitions>"
    exit 1
fi
    

STARTPOSITION=$(caget -t "${MOTOR}.RBV")
STARTSPEED=$(caget -t "${MOTOR}.VELO")

for (( rep=1 ; rep<=$3 ; rep++ )) ; do

    cawait "${MOTOR}.DMOV" 1

    caput "${MOTOR}.VELO" $2
    cawait "${MOTOR}.VELO" -w 1

    caput "${SHUT}:SHUTTEROPEN_CMD" 1
    cawait -n "${SHUT}:SHUTTEROPEN_MONITOR" 1

    log scan $rep beginning

    caput "${MOTOR}.RLV" $1

    # scans here
    echo -n "Scan $rep ... "
    cawait "${MOTOR}.DMOV" 1
    echo "done."

    log scan $rep end

    caput "${SHUT}:SHUTTEROPEN_CMD" 0
    cawait -n "${SHUT}:SHUTTEROPEN_MONITOR" 0

    caput "${MOTOR}.VELO" $STARTSPEED
    cawait "${MOTOR}.VELO" -w 1

    caput "${MOTOR}" $STARTPOSITION

    

done
