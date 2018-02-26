#!/bin/bash

if [ -z "${1}" ] ; then
  echo "No log name" 1>&2
  echo "0" 
  exit 1
fi


LOGPATH="/mnt/m.imbl/input"
LOGFILE="$LOGPATH/$1"
MOTIONMOTOR="SR08ID01DST21:Y"
MOTIONDISTANCE="870"
MOTIONSTART="-10"

caput "${MOTIONMOTOR}" "$MOTIONSTART" > /dev/null
sleep .5s
camonitor -t n "${MOTIONMOTOR}.DMOV" | sed -u "s/  \+/ /g" | 
while read pv state ; do
  if [ "$state" == "1" ] ; then
    killall camonitor
  fi
done

IC1PV="SR08ID01DAQ05:Measure"
IC2PV="SR08ID01DAQ04:Measure"
CURPV="SR11BCM01:CURRENT_MONITOR"

POS=$MOTIONSTART
IC1RD="$(caget -t $IC1PV)"
IC2RD="$(caget -t $IC2PV)"
CURRD="$(caget -t $CURPV)"


echo "# Starting new acquisition at Z $(caget -t SR08ID01TBL24:Z.RBV): $(date) " >> $LOGFILE


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
      #echo "${date}_${time}" $POS $IC1RD $IC2RD $CURRD >> $LOGFILE
      echo "${date}_${time}" $POS $(caget -t $IC1PV $IC2PV $CURPV) >> $LOGFILE
      ;;
    $IC1PV )  IC1RD="$val" ;;
    $IC2PV )  IC2RD="$val" ;;
    $CURPV )  CURRD="$val" ;;
    *      )  ;;  # TODO: implement OTHERPVS
  esac

done


caput "${MOTIONMOTOR}" "$MOTIONSTART" > /dev/null

echo 1

exit 0

