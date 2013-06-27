#~/bin/bash


cawait SR08ID01CCD01:Acquire_RBV 0

caput -t SR08ID01CCD01:Acquire 1 > /dev/null
cawait SR08ID01CCD01:Acquire_RBV 0

caput -t SR08ID01CCD01:WriteFile 1 > /dev/null
cawait SR08ID01CCD01:WriteFile_RBV Done



