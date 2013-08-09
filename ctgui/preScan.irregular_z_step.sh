#!/bin/bash


ZDS="$*"
#SERIALMOTORPV="SR08ID01MCS04:MTR32B"
SERIALMOTORPV="SR08ID01MCS06:MTR61A"


zcur=0;
foundz=""
for tryz in $ZDS ; do 
  if [ "$zcur" -eq "$CURRENTZ" ] ; then
    foundz="$tryz"
  fi
  zcur=$((zcur+1))
done

if [ -z "$foundz" ] ; then
  echo "Empty position"
  exit 1
fi

if echo $foundz | grep -Evq "^[0-9]*\.?[0-9]*$" ; then
  echo "Not a float point:" $foundz
  exit 1
fi


caput $SERIALMOTORPV $foundz
sleep 1s
cawait ${SERIALMOTORPV}.DMOV 1





exit 0

