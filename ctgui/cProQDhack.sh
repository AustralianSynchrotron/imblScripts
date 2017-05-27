#!/bin/bash

if [ -z "$1" ] ; then
  echo "Error. Exposure given."
  exit 1
fi

GOAL=$(caget -t ${ROTATIONMOTORPV}.VAL)
caput ${ROTATIONMOTORPV}.STOP 1
cawait ${ROTATIONMOTORPV}.DMOV 1
caput ${ROTATIONMOTORPV}.VELO $1
sleep 0.5s
caput ${ROTATIONMOTORPV} $GOAL
cawait ${ROTATIONMOTORPV}.DMOV 0
sleep (caget -t ${ROTATIONMOTORPV}.ACCL)

