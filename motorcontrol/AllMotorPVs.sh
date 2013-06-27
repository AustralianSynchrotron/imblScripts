#!/bin/bash

CONFIGFILE="/etc/motormx/listOfKnownMotorPVs.txt"

if [ -e $CONFIGFILE ] ; then # everywhere except for the motor's IOC

	cat $CONFIGFILE

else # motor's IOC

	FILELIST="\
		Enclosure_1A_Motors_WithWrappers.substitutions\
		Enclosure_1B2B_Motors_WithWrappers.substitutions"
	MDBDIR="/asp/ics/SR08ID01IOC41/db/"

	for file in ${FILELIST} ; do
		if [ -e "${MDBDIR}/${file}" ] ; then
			cat "${MDBDIR}/${file}"      \
				| grep SR08ID01      \
				| cut -d',' -f 1,2   \
				| sed -e 's/[{"]//g' \
				| sed -e "s/,/:/g"   \
				| sed -e "s/ //g"    \
				| grep "^#" -v 
		fi
	done

fi
