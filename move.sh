#!/bin/bash
source="$1"
destination="$2"

cleanSource=`echo "$source"|sed 's/\[.*\]\s*//'`
if [ "$source" != "$cleanSource" ]; then mv "$source" "$cleanSource"; source="$cleanSource";fi
torrentName=`basename "$source"`

while true
do
	lockfile -r 0 /tmp/move.lock &>/dev/null
	if [ $? -eq 0 ]; then break; fi
	sleep 5
done

while true
do
	#Upload to ACD and prevent post-processor from running
	mv -f "$source" "${destination}${torrentName}!sync"
	if [ $? -ne 0 ]
	then 
		/root/remount.sh
	else
		#When uploaded, make the file available for post processor
		mv -f "${destination}${torrentName}!sync" "${destination}${torrentName}"
		break
	fi
	sleep 5
done
rm -f /tmp/move.lock
