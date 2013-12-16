#!/bin/bash

LOG="l2l.$(date +%Y-%m-%d_%H.%M.%S).log"

if [ -z "$1" ] ; then
    echo "Error. No motor given."
    echo "Usage: $0 <motor> <repetitions>"
    exit 1
fi
MOTOR="$1"

if ! caget -t "${MOTOR}" &> /dev/null ; then
     echo "Error. Motor $MOTOR is not conected."
     exit 1
fi

if [ -z "$2" ] ; then
    echo "Error. No repetitions given."
    echo "Usage: $0 <motor> <repetitions>"
    exit 1
fi
REPS="$2"

NegativeSoftLimit=$(echo $(caget -t ${MOTOR}.LLM) + 2.0 \* $(caget -t ${MOTOR}.BDST | sed -e 's -  g') | bc)
PositiveSoftLimit=$(echo $(caget -t ${MOTOR}.HLM) - 2.0 \* $(caget -t ${MOTOR}.BDST | sed -e 's -  g') | bc)

cawait "${MOTOR}.DMOV" 1

for (( rep=1 ; rep<=$REPS ; rep++ )) ; do

    #caput -t ${MOTOR} $NegativeSoftLimit
    caput -t ${MOTOR} -50
    sleep 2s
    cawait "${MOTOR}.DMOV" 1
    echo NEGATIVE $(caget -t ${MOTOR}.RBV)

    #caput -t ${MOTOR} $PositiveSoftLimit 
    caput -t ${MOTOR} 300 
    sleep 1s
    cawait "${MOTOR}.DMOV" 1
    echo POSITIVE $(caget -t ${MOTOR}.RBV)

done
