#!/bin/bash

MOT1="SR08ID01SST01:SAMPLEY"
MOT2="SR08ID01SST01:SAMPLEX"
ROT="SR08ID01SST01:ROTATION"

isunplugged () {
  caget -t "${MOT1}.LLS" "${MOT1}.HLS" | grep -q 1   && \
  caget -t "${MOT2}.LLS" "${MOT2}.HLS" | grep -q 1 
  ret="$?"
  #echo RET $ret
  return $ret
}

camonitor -p 99 -n -S "${MOT1}.LLS" "${MOT1}.HLS" "${MOT2}.LLS" "${MOT2}.HLS" | sed -u "s/  \+/ /g" |
while read line ; do
  if isunplugged ; then
    caput "${ROT}.HLM" 400
    caput "${ROT}.LLM" -400
    echo UNPLUGGED
  else
    caput "${ROT}.HLM" 137
    caput "${ROT}.LLM" -47
    echo PLUGGED
  fi
done


