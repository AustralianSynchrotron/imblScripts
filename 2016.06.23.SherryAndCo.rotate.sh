#!/bin/bash

ROT="SR08ID01SST01:ROTATION"
POS=$(caget -t "${ROT}.RBV")
VEL=$(caget -t "${ROT}.VELO")



if [ -n "$1" ] ; then
  caput "${ROT}.VELO" "$1"
fi

caput ${ROT} 380
sleep 1s
while [ "$(caget -t ${ROT}.DMOV)" == "0" ] ; do
  sleep 0.5s
done

caput "${ROT}.VELO" $VEL
caput ${ROT} $POS 
sleep 1s
while [ "$(caget -t ${ROT}.DMOV)" == "0" ] ; do
  sleep 0.5s
done




