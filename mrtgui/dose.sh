if [ "$#" -ne 1 ]
then
   echo You need to enter the dose required
   exit 1 
fi

RC="SR11BCM01:CURRENT_MONITOR"
flaskpoints=39
chamberpoints=48
flaskcolumns=3
chambercolumns=2
flaskdwell=4530
chamberdwell=4670

current=`caget -t $RC`
exposure=$(echo \($1*200/.0574\)/${current}|bc)
echo
echo -e "The ring current is \e[00;31m${current}mA\e[00m. The exposure required for ${1}Gy is \e[00;31m${exposure}ms\e[00m"

duration=$(($flaskpoints*$flaskcolumns*($flaskdwell+$exposure)/60000))
chamberduration=$(($chamberpoints*$chambercolumns*($chamberdwell+$exposure)/60000))
echo -e "The expected flask duration is \e[00;31m$duration minutes\e[00m. This should happen at \e[00;31m$(date  -d @$(($(date +%s)+$duration*60)) +%R%p)\e[00m"
echo -e "The expected chamber slide duration is \e[00;34m$chamberduration minutes\e[00m. This should happen at \e[00;34m$(date  -d @$(($(date +%s)+$chamberduration*60)) +%R%p)\e[00m"
echo
