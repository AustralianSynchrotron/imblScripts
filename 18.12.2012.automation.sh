#!/bin/bash

# MUST BE FLOAT POINT, that is MUST HAVE DOT
POSS="
Kapton_138.0
Tube7_106.0
Tube6_86.0
Cylinders_71.0
Tube4_53.0
Tube1_25.0
Flat_0.0
"

MOTORTOMOVE="SR08ID01MCS09:MTR64H"
CCDCA="SR08ID01DET01"

acquire() {

        # I better wait for the writing before acquisition rather than after
        #cawait  "${CCDCA}:CAM1:Acquire" Done

	sleep 1s

        ARR=""
        SUM=1
        for ch in $(echo "${1}" | sed 's/\(.\)/\1 /g') ; do
          NUM=$(printf "%d\n" "'${ch}")
          ARR="${ARR} ${NUM}"
          let "SUM +=1"
        done
        ARR="${SUM} ${ARR} 0"

        eval caput -a "${CCDCA}:TIFF1:FileName" $ARR
        caput "${CCDCA}:TIFF1:FileNumber" 1 

        caput "${CCDCA}:CAM:Acquire" Acquire 
        cawait  "${CCDCA}:CAM:Acquire" Done

}

moveMotor() {
        caput $1 $2
        sleep 1s
        cawait "${1}.DMOV" 1
}


for curln in $POSS ; do
	nam=$(echo $curln | cut -d'_' -f 1)
	pos=$(echo $curln | cut -d'_' -f 2)
 	moveMotor $MOTORTOMOVE $pos
	acquire "${nam}_"
done



