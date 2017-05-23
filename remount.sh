#!/bin/bash
lockfile -r 0 /tmp/remount.lock || exit 1
cd ~ && fusermount -u acd
ps aux |grep -i python3 |grep -i acd_cli|grep -v grep|awk '{print $2}'|xargs -r kill -9
rm  -f ~/.cache/acd_cli/nodes.db
acdcli sync
acdcli mount -ao -i 30 ~/acd 2>&1 1>/dev/null
EC=$?
rm -f /tmp/remount.lock
exit $EC
