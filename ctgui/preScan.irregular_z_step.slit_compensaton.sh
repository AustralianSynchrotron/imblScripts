#!/bin/bash


ZDS="$*"

SERIALMOTORPV="SR08ID01MCS04:MTR32B"
COMPENSATEPOSMOTORPV="SR08ID01:MTR31A"
COMPENSATENEGMOTORPV="SR08ID01:MTR31B"

zcur=0;
foundz=""
for tryz in $ZDS ; do 
  if [ "$zcur" -eq "$CURRENTSCAN" ] ; then
    foundz="$tryz"
  fi
  zcur=$((zcur+1))
done

if [ -z "$foundz" ] ; then
  echo "Empty position"
  exit 1
fi

if echo $foundz | grep -Evq "^[\-0-9]*\.?[0-9]*$" ; then
  echo "Not a float point:" $foundz
  exit 1
fi

oldzpos=$( caget -t ${SERIALMOTORPV}.RBV )
delta=$( echo "$foundz - $oldzpos" | bc )

caput -t  $SERIALMOTORPV $foundz
caput -t  $COMPENSATEPOSMOTORPV.RLV $delta
caput -t  $COMPENSATENEGMOTORPV.RLV $( echo " 0 - $delta " | bc  )

sleep 1s
cawait ${SERIALMOTORPV}.DMOV 1
cawait ${COMPENSATEPOSMOTORPV}.DMOV 1
cawait ${COMPENSATENEGMOTORPV}.DMOV 1


exit 0

