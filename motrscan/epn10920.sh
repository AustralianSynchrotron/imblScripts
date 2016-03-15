#!/bin/bash

if [ -z "${1}" ] ; then
  echo "No travel distance given" 1>&2
  echo "0" 
  exit 1
fi

LOGFILE="log.dat"
MOTIONMOTOR="SR08ID01DST31:Y"
MOTIONDISTANCE="$1"
MOTIONSTART="$(caget -t ${MOTIONMOTOR}.RBV)"

IC1PV="SR08ID01DAQ03:Measure"
IC2PV="SR08ID01DAQ04:Measure"
CURPV="SR11BCM01:CURRENT_MONITOR"

POS=$MOTIONSTART
IC1RD="$(caget -t $IC1PV)"
IC2RD="$(caget -t $IC2PV)"
CURRD="$(caget -t $CURPV)"


echo "# Starting new acquisition: $(date) " >> $LOGFILE


caput "${MOTIONMOTOR}.RLV" "$MOTIONDISTANCE" > /dev/null
sleep .5s

camonitor -p 99 -n -S "${MOTIONMOTOR}.RBV" "${MOTIONMOTOR}.DMOV" $LOGPVS | sed -u "s/  \+/ /g" |
while read pv date time val ; do

  case "$pv" in
    ${MOTIONMOTOR}.DMOV ) 
      if [ "$val" == "1" ] ; then
         echo "# Finishing acquisition: $(date)" >> $LOGFILE
         killall camonitor
      fi
      ;;
    ${MOTIONMOTOR}.RBV )
      POS="$val"
      echo "${date}_${time}" $IC1RD $IC2RD $CURRD >> $LOGFILE
      ;;
    $IC1PV )  IC1RD="$val" ;;
    $IC2PV )  IC2RD="$val" ;;
    $CURPV )  CURRD="$val" ;;
    *      )  ;;  # TODO: implement OTHERPVS
  esac

done


caput "${MOTIONMOTOR}" "$MOTIONSTART" > /dev/null
sleep .5s
camonitor -t n "${MOTIONMOTOR}.DMOV" | sed -u "s/  \+/ /g" | 
while read pv state ; do
  if [ "$state" == "1" ] ; then
    killall camonitor
  fi
done

echo 1

exit 0

