#!/bin/bash



DETPV="SR08ID01DET04"
MOT="SR08ID01DST31:Y"

IMAGEMODE=$(caget -t $DETPV:CAM:ImageMode)
IMAGENAME=$(caget -t -S $DETPV:TIFF:FileName)
STARTPOS=$(caget -t $MOT.RBV)

caput $DETPV:CAM:ImageMode Single

NMTEMPL=$1
if [ -z "$1" ] ; then
	NMTEMPL=$IMAGENAME
fi


moveMotor() {
        caput $1 $2
        sleep 1s
        cawait "${1}.DMOV" 1
}

shot() {

	caput -t $DETPV:CAM:Acquire 0 > /dev/null
	cawait $DETPV:CAM:Acquire_RBV Done

	caput -t $DETPV:CAM:Acquire 1 > /dev/null
	sleep 1s
	cawait $DETPV:CAM:Acquire_RBV Done

        caput -S $DETPV::TIFF:FileName "$1"

	caput -t $DETPV:TIFF:WriteFile 1 > /dev/null
	cawait $DETPV:TIFF:WriteFile_RBV Done

	caget -t -S $DETPV:TIFF:FullFileName_RBV

}



moveMotor $MOT 310
LISTIMG=$( basename $(shot NMTEMPL_1_) )

moveMotor $MOT 490
LISTIMG="${LISTIMG} $( basename $(shot NMTEMPL_2_) )"
 
moveMotor $MOT 670
LISTIMG="${LISTIMG} $( basename $(shot NMTEMPL_3_) )"

caput $DETPV:CAM:ImageMode $IMAGEMODE

caput $MOT $STARTPOS











    



