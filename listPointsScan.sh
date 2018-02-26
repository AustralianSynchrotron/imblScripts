#!/bin/bash

if [ -z "$1" ] ; then
  echo "Error. No image base name given."
  exit 1
fi
IMAGEBASENAME="$1"

LISTFILE="XYpositions.txt"

MOTORXPV=""
MOTORYPV=""
DETPV=""

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
  echo shot $IMAGEBASENAME.X$xpos.Y$ypos
done
