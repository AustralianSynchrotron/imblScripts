#!/bin/bash

SHUT="SR08ID01MRT01"




# bl shutter

caput SR08ID01PSS01:HU01A_BL_SHUTTER_OPEN_CMD 1
cawait SR08ID01PSS01:HU01A_SF_SHUTTER_OPEN_STS 1
cawait SR08ID01PSS01:HU01A_PH_SHUTTER_OPEN_STS 1







#openning 

      caput "${SHUT}:SHUTTEROPEN_CMD" 1
      cawait -n "${SHUT}:SHUTTEROPEN_MONITOR" 1




# closing 
      caput "${SHUT}:SHUTTEROPEN_CMD" 0
      cawait -n "${SHUT}:SHUTTEROPEN_MONITOR" 0

