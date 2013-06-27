#!/bin/bash

SCALER="SR08ID01:scaler1"
OUTPUTFILE="mrt.log"

# Stop counting if it was
caput ${SCALER}.CNT "Done" > /dev/null


#timestamp
echo -n $(date +"%F_%T.%N") " " | tee -a "$OUTPUTFILE"

# get channel(s)
getChannel() {
	CHANNELS=""
	for ch in $@ ; do
		CHANNELS="${CHANNELS} ${SCALER}.S${ch}"
	done
	echo -n $(caget -t ${CHANNELS})
}

getChannel 5 6 7 8 | tee -a "$OUTPUTFILE"
echo | tee -a "$OUTPUTFILE"

