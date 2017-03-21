#!/bin/bash

LOG="tiledscan.log"

if [ -z "$1" ] ; then
  echo "Error. No Y start given." >> $LOG
  exit 1
fi
HSTART=$1

if [ -z "$2" ] ; then
  echo "Error. No Y step given." >> $LOG
  exit 1
fi
HSTEP=$2

if [ -z "$3" ] ; then
  echo "Error. No Y number of scans given." >> $LOG
  exit 1
fi
HSCANS=$3

if [ -z "$4" ] ; then
  echo "Error. No Z start given." >> $LOG
  exit 1
fi
VSTART=$4

if [ -z "$5" ] ; then
  echo "Error. No Z step given." >> $LOG
  exit 1
fi
VSTEP=$5

MOTORH="SR08ID01ROB01:MOTOR_Z"
MOTORV="SR08ID01ROB01:MOTOR_Y"

HCUR=$(( $CURRENTSCAN % $HSCANS  ))
VCUR=$(( $CURRENTSCAN / $HSCANS  ))

HPOS=$(echo "scale=2; $HSTART + $HCUR * $HSTEP" | bc)
VPOS=$(echo "scale=2; $VSTART + $VCUR * $VSTEP" | bc)
 
movemotor() {
  caput $1 $2
  sleep 1s
  cawait ${1}.DMOV 1
}


movemotor $MOTORH $HPOS
movemotor $MOTORV $VPOS


echo $CURRENTSCAN  >> /home/imbl/work/projects/scripts/ctgui/test.log
caget $MOTORH $MOTORV >> /home/imbl/work/projects/scripts/ctgui/test.log
echo >> /home/imbl/work/projects/scripts/ctgui/test.log


exit 0

