#!/bin/bash

LOG="l2p.$(date +%Y-%m-%d_%H.%M.%S).log"

if [ -z "$1" ] ; then
    echo "Error. No motor given."
    echo "Usage: $0 <motor> <step> <repetitions>"
    exit 1
fi
MOTOR="$1"

if ! caget -t "${MOTOR}" &> /dev/null ; then
     echo "Error. Motor $MOTOR is not conected."
     exit 1
fi

if [ -z "$2" ] ; then
    echo "Error. No step given."
    echo "Usage: $0 <motor> <step> <repetitions>"
    exit 1
fi
STEP="$2"

if [ -z "$3" ] ; then
    echo "Error. No repetitions given."
    echo "Usage: $0 <motor> <step> <repetitions>"
    exit 1
fi
REPS="$3"

NegativeSoftLimit=$(echo $(caget -t ${MOTOR}.LLM) + 2.0 \* $(caget -t ${MOTOR}.BDST | sed -e 's -  g') | bc)
PositiveSoftLimit=$(echo $(caget -t ${MOTOR}.HLM) - 2.0 \* $(caget -t ${MOTOR}.BDST | sed -e 's -  g') | bc)

cawait "${MOTOR}.DMOV" 1

for (( rep=1 ; rep<=$REPS ; rep++ )) ; do

    if [ "${STEP:0:1}" = "-" ] ; then
      caput -t ${MOTOR}.RLV ${STEP}
    else
      caput -t ${MOTOR} $NegativeSoftLimit
      #caput -t ${MOTOR} -50
    fi
    sleep 2s
    cawait "${MOTOR}.DMOV" 1
    echo NEGATIVE $(caget -t ${MOTOR}.RBV)

    if [ "${STEP:0:1}" = "-" ] ; then
      caput -t ${MOTOR} $PositiveSoftLimit 
      #caput -t ${MOTOR} 300 
    else
      caput -t ${MOTOR}.RLV ${STEP}
    fi
    sleep 1s
    cawait "${MOTOR}.DMOV" 1
    echo POSITIVE $(caget -t ${MOTOR}.RBV)

done
