#!/bin/bash

CCDCA="SR08ID01DET01"
#CCDCA="" # Graphite


aq() {
	# I better wait for the writing before acquisition rather than after
	cawait  "${CCDCA}:CAM:Acquire" Done 2> /dev/null

	ARR=""
	SUM=1
	for ch in $(echo "$1" | sed 's/\(.\)/\1 /g') ; do
		NUM=$(printf "%d\n" "'${ch}")
		ARR="${ARR} ${NUM}"
		SUM=$((SUM+1))
	done
	ARR="${SUM} ${ARR} 0"

	echo Acquire ${1}
	#echo Acquire ${FILE} Scan: ${SCANPOS} BG: ${TRANSPOS}    >> log.txt

	eval caput -a "${CCDCA}:TIFF1:FileName" $ARR > /dev/null

	caput "${CCDCA}:CAM:Acquire" Acquire > /dev/null
	cawait  "${CCDCA}:CAM:Acquire" Done 2> /dev/null
	#caput "${CCDCA}:TIFF1:WriteFile" 1 > /dev/null
}



BGMOT="SR08ID01MCS09:MTR64H"
BGDIST="-50"
SHPV="SR08ID01PSS01:HU01A_BL_SHUTTER_"

caput "${SHPV}OPEN_CMD" 1 > /dev/null
sleep 2s

aq "pr-$1.tif"
caput "${BGMOT}.RLV" $BGDIST > /dev/null
sleep 0.3s
cawait  "${BGMOT}.DMOV" 1 2> /dev/null
aq "bg-$1.tif"
caput "${BGMOT}.RLV" $((-1*$BGDIST)) > /dev/null

caput "${SHPV}CLOSE_CMD" 1 > /dev/null



