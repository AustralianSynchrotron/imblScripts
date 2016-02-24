#!/bin/bash

SHBASE="SR08ID01IS01"
MANCMD=""

if [ "$1" == "open" ] ; then 
  caput "${SHBASE}:SHUTTEROPEN_CMD" 1
elif [ "$1" == "close" ] ; then
  caput "${SHBASE}:SHUTTEROPEN_CMD" 0
else
  STS=$(caget -t "${SHBASE}:SHUTTEROPEN_MONITOR" )  
  if [ "$STS" == "Opened" ] ; then
    caput "${SHBASE}:SHUTTEROPEN_CMD" 0
  elif [ "$STS" == "Closed" ] ; then
    caput "${SHBASE}:SHUTTEROPEN_CMD" 1
  fi
fi

    



