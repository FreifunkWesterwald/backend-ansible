#!/usr/bin/env bash

while true; do
  for int in /sys/class/net/{bb*,bat*,wg*}; do
    echo 'bbstat,interface="'$(basename $int)\
'",node="'$(hostname)'"'\
' '\
'rx-bytes='$(cat $int/statistics/rx_bytes)\
',tx_bytes='$(cat $int/statistics/tx_bytes)\
',rx_packets='$(cat $int/statistics/rx_packets)\
',tx_packets='$(cat $int/statistics/tx_packets)\
' '\
$(date +%s);
  done | curl -s -X POST 'http://freifunk.tools:8086/write?db=ffww&precision=s' --data-binary @-
  sleep 10
done