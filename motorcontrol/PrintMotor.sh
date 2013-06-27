#!/bin/bash

FIELDS="EGU PREC LLM HLM MRES UREV SREV OFF DIR VMAX VELO BVEL JVEL S ACCL BACC JAR BDST"

printOneMotor() {

  if [ -z "$1" ] ; then
	return 0
  fi

  ALLPVS=""
  for fld in $FIELDS; do
    ALLPVS="$ALLPVS $1.$fld "
  done

  OUTSTRING=$(caget -t $ALLPVS 2>/dev/null)
  if [ $? -eq 0 ] ; then
    echo $1: $OUTSTRING \"$(caget -t $1.DESC)\"
    return $?
  else
    echo "Could not get information for motor \"$1\"." >&2
    return 1
  fi 

}


beverbose=false
if [ "$1" == "-v" ] ; then
  beverbose=true
  echo "#" PV Units Precision LoLimit HiLimit Units-per-step Units-per-revolution Steps-per-revolution Offset Direction MaxSpeed Speed BacklashSpeed JogSpeed Steps-per-second Acceleration BacklashAcceleration JogAcceleration Backlash Description 
  echo "#" PV $FIELDS DESC
  shift
fi


if [ -z "$1" ] ; then
  $0 $(AllMotorPVs.sh)
  exit $?
else
  ret=0
  for mot in $@ ; do
    if ! printOneMotor $mot ; then
      ret=1
    fi
  done
  exit $ret
fi
 
