#!/bin/bash

USAGE="Usage: $0 <y-list> <z-travel> <z-repetitions> <z-speed> [samplename]"

ZMOTOR="SR08ID01MCS09:MTR64G"
YMOTOR="SR08ID01MCS09:MTR64E"
SHUT="SR08ID01IS01"

PVSTOLOG="\
SR08ID01MOX09:Keithley4:Measure \
SR08ID01MOX01:Keithley2:Measure \
SR11BCM01:CURRENT_MONITOR \
${ZMOTOR}.RBV \
"

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
    echo "Error. No list of Y positions is given."
    echo $USAGE
    exit 1
fi
YLIST="$1"
if [ ! -e "$YLIST" ] ; then
    echo "File with the list of Y positions \"$YLIST\" does not exist."
    exit 1
fi
if [ ! -r "$YLIST" ] ; then
    echo "File with the list of Y positions \"$YLIST\" cannot be read."
    exit 1
fi

if [ -z "$2" ] ; then
    echo "Error. No Z travel given."
    echo $USAGE
    exit 1
fi
ZTRAVEL="$2"

if [ -z "$3" ] ; then
    echo "Error. No Z repetitions given."
    echo $USAGE
    exit 1
fi
ZREPIT="$3"

if [ -z "$4" ] ; then
    echo "Error. No Z speed given."
    echo $USAGE
    exit 1
fi
ZSPEED="$4"

LOG=""
if [ -z "$5" ] ; then
    LOG="scanthrough"
else
    LOG="$5"
fi
LOG="${LOG}.$(date +%Y-%m-%d_%H.%M.%S).log"

log () {
	echo $(date +%Y-%m-%d_%H:%M:%S) "$*"  >> "$LOG"
}



echo "# executed string: $0 $*" >> "$LOG"
echo "# logged PVs: $PVSTOLOG" >> "$LOG"

ZSTARTPOSITION=$(caget -t "${ZMOTOR}.RBV")
ZSTARTSPEED=$(caget -t "${ZMOTOR}.VELO")
YSTARTPOSITION=$(caget -t "${YMOTOR}.RBV")

BREAKME=false

yrep=0

cat "$YLIST" |
while read YPOS ; do

    ((yrep++))
    
    echo -n "Scan $yrep at $YPOS "

    caput "${YMOTOR}" $YPOS > /dev/null
    sleep 0.2s
    cawait "${YMOTOR}.DMOV" 1

    for (( rep=1 ; rep<=$ZREPIT ; rep++ )) ; do

      cawait "${ZMOTOR}.DMOV" 1

      caput "${ZMOTOR}.VELO" $ZSPEED > /dev/null
      cawait "${ZMOTOR}.VELO" -w 1

      caput "${SHUT}:SHUTTEROPEN_CMD" 1 > /dev/null
      cawait -n "${SHUT}:SHUTTEROPEN_MONITOR" 1

      log "scan Y$yrep y-position="$(caget -t ${YMOTOR}.RBV) "Z$rep"
      log "     PVs in the biginning:" $(caget -t $PVSTOLOG)

      caput "${ZMOTOR}.RLV" $ZTRAVEL > /dev/null

     # scans here
      echo -n "."

      sleep 1s
      if caget -t ${ZMOTOR}.DMOV | grep 1 -q ; then
         log scan Y$yrep Z$rep FAILED
	 caput "${SHUT}:SHUTTEROPEN_CMD" 0 > /dev/null
	 caput "${YMOTOR}" $YSTARTPOSITION > /dev/null
         echo 
         echo "ERROR HAPPENED: THE Z MOTOR DID NOT START"
         echo "TERMINATING THE SCRIPT"
         echo
      fi
 
      cawait "${ZMOTOR}.DMOV" 1

      log "     PVs in the end:" $(caget -t $PVSTOLOG)

      caput "${SHUT}:SHUTTEROPEN_CMD" 0 > /dev/null
      cawait -n "${SHUT}:SHUTTEROPEN_MONITOR" 0

      caput "${ZMOTOR}.VELO" $ZSTARTSPEED > /dev/null
      cawait "${ZMOTOR}.VELO" -w 1

      caput "${ZMOTOR}" $ZSTARTPOSITION > /dev/null

    done
    
    echo " done."	

done

caput "${SHUT}:SHUTTEROPEN_CMD" 0 > /dev/null


caput "${YMOTOR}.STOP" 1 > /dev/null
cawait "${YMOTOR}.DMOV" 1

caput "${YMOTOR}" $YSTARTPOSITION > /dev/null
cawait "${YMOTOR}.DMOV" 1

