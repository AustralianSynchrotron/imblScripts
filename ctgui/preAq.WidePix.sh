#!/bin/bash

if [ -z "$1" ] ; then
  echo "Error. No exposure given."
  exit 1
fi

#if [ -z "$2" ] ; then
#  echo "Error. No file path given." >> $LOG
#  exit 1
#fi

#ssh imbl@10.123.10.30 "echo MULTCAP $1 $DETAQNUM $PWD ${DETFILENAME}_%1.tif | nc localhost 8080"
#ssh imbl@10.123.10.41 "echo MULTCAP $1 $DETAQNUM $PWD ${DETFILENAME}_%1.tif | nc localhost 8080"
echo MULTCAP $1 $DETAQNUM $PWD ${DETFILENAME}_%1.tif | nc localhost 8080
caput ${ROTATIONMOTORPV}.STOP 1
killall -9 postAq.WidePix.sh 
