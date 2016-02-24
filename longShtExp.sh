#!/bin/bash

if [ -z "$1" ] ; then
  echo "Error. No exposure given." >> $LOG
  exit 1
fi


SHBASE="SR08ID01IS01"
caput "${SHBASE}:SHUTTEROPEN_CMD" 1
sleep $1
caput "${SHBASE}:SHUTTEROPEN_CMD" 0



