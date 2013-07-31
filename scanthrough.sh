#!/bin/bash

ZMOTOR="SR08ID01MCS03:MTRC"
SHUT="SR08ID01IS01"
LOG="scanthrough.$(date +%Y-%m-%d_%H.%M.%S).log"

YMOTOR=""
YTRAVEL="1"
YREPIT="1"

log () {
	echo $* $(date +%Y-%m-%d_%H:%M:%S) >> $LOG
	caget keithley:unit2:Measure keithley:unit4:Measure >> $LOG
}


if ! caget -t "${ZMOTOR}" &> /dev/null ; then
     echo "Error. Motor $ZMOTOR is not conected."
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
    

ZSTARTPOSITION=$(caget -t "${ZMOTOR}.RBV")
ZSTARTSPEED=$(caget -t "${ZMOTOR}.VELO")

YSTARTPOSITION=$(caget -t "${YMOTOR}.RBV")



for (( yrep=1 ; yrep<=$YREPIT ; yrep++ )) ; do

    cawait "${YMOTOR}.DMOV" 1

    for (( rep=1 ; rep<=$3 ; rep++ )) ; do

      cawait "${ZMOTOR}.DMOV" 1

      caput "${ZMOTOR}.VELO" $2
      cawait "${ZMOTOR}.VELO" -w 1

      caput "${SHUT}:SHUTTEROPEN_CMD" 1
      cawait -n "${SHUT}:SHUTTEROPEN_MONITOR" 1

      log scan $yrep $rep beginning

      caput "${ZMOTOR}.RLV" $1

      # scans here
      echo -n "Scan $rep ... "
      cawait "${ZMOTOR}.DMOV" 1
      echo "done."

      log scan $yrep $rep end

      caput "${SHUT}:SHUTTEROPEN_CMD" 0
      cawait -n "${SHUT}:SHUTTEROPEN_MONITOR" 0

      caput "${ZMOTOR}.VELO" $ZSTARTSPEED
      cawait "${ZMOTOR}.VELO" -w 1

      caput "${ZMOTOR}" $ZSTARTPOSITION

    done

    caput "${YMOTOR}.RLV" $YTRAVEL
    sleep 0.2s

done

caput "${YMOTOR}.STOP" 1
cawait "${YMOTOR}.DMOV" 1

caput "${YMOTOR}" $YSTARTPOSITION
cawait "${YMOTOR}.DMOV" 1

