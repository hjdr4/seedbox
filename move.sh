#!/bin/bash
source="$1"
destination="$2"

while true
do
	mv -f "$source" "$destination"
	if [ $? -ne 0 ]
	then 
		/root/remount.sh
	else
		break
	fi
	sleep 5
done
