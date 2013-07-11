#~/bin/bash

BASEPV="SR08ID01DET01"

cawait $BASEPV:CAM:Acquire_RBV Done 

caput -t $BASEPV:CAM:Acquire 1 > /dev/null
sleep 0.1s
cawait $BASEPV:CAM:Acquire_RBV Done

caput -t $BASEPV:TIFF1:WriteFile 1 > /dev/null
cawait $BASEPV:TIFF1:WriteFile_RBV Done



