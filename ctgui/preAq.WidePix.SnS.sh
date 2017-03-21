#!/bin/bash

if [ -z "$1" ] ; then
  echo "Error. Exposure given."
  exit 1
fi

if [ -z "$2" ] ; then
  echo "Error. No file path given." >> $LOG
  exit 1
fi

ssh imbl@10.123.10.41 "echo MULTCAP $1 $DETAQNUM $2 ${DETFILENAME}.tif | nc localhost 8080"
