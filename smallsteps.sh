#!/bin/nash

MOTOR="$1"

cawait "${MOTOR}.DMOV" 1

keepgoing="true"

while [ "$keepgoing" == "true" ] ; do

	caput "${MOTOR}.TWR" 1
	sleep 0.5s
	cawait "${MOTOR}.DMOV" 1

	
	motpos=$(caget -t "${MOTOR}.RBV")
	encpos=$(caget -t "${MOTOR}:ENCODER")
	delta=$( echo "$motpos - $encpos - 1.232 " | bc )
	delta=${delta/-/}

	echo $delta

	if [ $(bc <<< "$delta <= 0.1") -ne 1 ] ; then
		echo 1
		keepgoing="false"
	fi
	if  caget -t ${MOTOR}.LLS | grep -q 1; then
		echo 2
		keepgoing="false"
	fi
	if caget -t ${MOTOR}.HLS | grep -q 1  ; then
		echo 3
		keepgoing="false"
	fi
	if  caget -t SR08ID01MCS01:ASYN1.AINP | grep -q 1; then
		echo 4
		keepgoing="false"
	fi
	if  caget -t SR08ID01MCS02:ASYN2.AINP | grep -q 1  ; then
		echo 5
		keepgoing="false"
	fi

done

