#!/bin/bash

USAGE="Usage: $0 <y-step> <y-repetitions> <z-travel> <z-repetitions> <z-speed>"

ZMOTOR="SR08ID01MCS04:MTR32H"
YMOTOR="SR08ID01MCS04:MTR32E"
SHUT="SR08ID01IS01"
LOG="scanthrough.$(date +%Y-%m-%d_%H.%M.%S).log"

log () {
	echo $* $(date +%Y-%m-%d_%H:%M:%S) >> $LOG
	caget keithley:unit2:Measure keithley:unit4:Measure >> $LOG
}


if ! caget -t "${ZMOTOR}" &> /dev/null ; then
     echo "Error. Motor $ZMOTOR is not conected."
     exit 1
fi

if ! caget -t "${YMOTOR}" &> /dev/null ; then
     echo "Error. Motor $ZMOTOR is not conected."
     exit 1
fi

if ! caget -t "${SHUT}:EXPOSUREPERIOD_MONITOR" &> /dev/null ; then
     echo "Error. Shutter $SHUT is not conected."
     exit 1
fi

if [ -z "$1" ] ; then
    echo "Error. No Y step given."
    echo $USAGE
    exit 1
fi
YTRAVEL="$1"

if [ -z "$2" ] ; then
    echo "Error. No Y repetitions given."
    echo $USAGE
    exit 1
fi
YREPIT="$2"

if [ -z "$3" ] ; then
    echo "Error. No Z travel given."
    echo $USAGE
    exit 1
fi
ZTRAVEL="$3"

if [ -z "$4" ] ; then
    echo "Error. No Z repetitions given."
    echo $USAGE
    exit 1
fi
ZREPIT="$4"

if [ -z "$5" ] ; then
    echo "Error. No Z speed given."
    echo $USAGE
    exit 1
fi
ZSPEED="$5"

    

ZSTARTPOSITION=$(caget -t "${ZMOTOR}.RBV")
ZSTARTSPEED=$(caget -t "${ZMOTOR}.VELO")

YSTARTPOSITION=$(caget -t "${YMOTOR}.RBV")



for (( yrep=1 ; yrep<=$YREPIT ; yrep++ )) ; do

    cawait "${YMOTOR}.DMOV" 1

    for (( rep=1 ; rep<=$ZREPIT ; rep++ )) ; do

      cawait "${ZMOTOR}.DMOV" 1

      caput "${ZMOTOR}.VELO" $ZSPEED
      cawait "${ZMOTOR}.VELO" -w 1

      caput "${SHUT}:SHUTTEROPEN_CMD" 1
      cawait -n "${SHUT}:SHUTTEROPEN_MONITOR" 1

      log scan Y$yrep Z$rep beginning

      caput "${ZMOTOR}.RLV" $ZTRAVEL

      # scans here
      echo -n "Scan $rep ... "
      cawait "${ZMOTOR}.DMOV" 1
      echo "done."

      log scan Y$yrep Z$rep end

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

