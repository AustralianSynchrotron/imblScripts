if [ "$#" -ne 1 ]
then
   echo You need to enter the exposure required
   exit 1 
fi

RC="SR11BCM01:CURRENT_MONITOR"
flaskpoints=39
flaskcolumns=3
flaskdwell=4530

current=`caget -t $RC`
dose=$(echo scale=10\;\($1*.0574/200\)*${current}|bc)
echo
echo -e "The ring current is \e[00;31m${current}mA\e[00m. The dose for ${1}ms of exposure  is \e[00;31m${dose}Gy\e[00m"

duration=$(($flaskpoints*$flaskcolumns*($flaskdwell+$1)/60000))
echo -e "The expected duration is \e[00;31m$duration minutes\e[00m. This should happen at \e[00;31m$(date  -d @$(($(date +%s)+$duration*60)) +%R%p)\e[00m"
echo
