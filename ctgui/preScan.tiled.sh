#!/bin/bash



ZDS="$*"
#SERIALMOTORPV="SR08ID01MCS04:MTR32B"
#SERIALMOTORPV="SR08ID01MCS06:MTR61A"

MOTORH="SR08ID01SST02:Y"
MOTORV="SR08ID01SST02:Z"
HSTEP=27
VSTEP=21.2
HSTART=-40.5
VSTART=-11
HSCANS=4
#VSCANS=6
#ASCANS=$(( $HSCANS * $VSCANS ))

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

