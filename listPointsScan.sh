#!/bin/bash

if [ -z "$1" ] ; then
  echo "Error. No input list given"
  exit 1
fi
LISTFILE="$1"

MOTORXPV="SR08ID01SST02:Y"
MOTORYPV="SR08ID01SST02:Z"
DETPV="SR08ID01DET02"

moveMotor() {
  caput $1 $2
  sleep 1s
  cawait "${1}.DMOV" 1
}

shot() {

  caput -t $DETPV:CAM:Acquire 0 > /dev/null
  cawait $DETPV:CAM:Acquire_RBV Done

  caput -t $DETPV:CAM:Acquire 1 > /dev/null
  sleep 1s
  cawait $DETPV:CAM:Acquire_RBV Done

  caput -S $DETPV:TIFF:FileName "$1" > /dev/null
  caput -t $DETPV:TIFF:WriteFile 1 > /dev/null
  cawait $DETPV:TIFF:WriteFile_RBV Done
  caget -t -S $DETPV:TIFF:FullFileName_RBV

}


cat $LISTFILE |
while read xpos ypos ; do
  echo X $xpos Y $ypos
  moveMotor $MOTORXPV $xpos
  moveMotor $MOTORYPV $ypos
  sleep 0.1s
  shot "$(basename $LISTFILE)_X${xpos}_Y${ypos}"
done
