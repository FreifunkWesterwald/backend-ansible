#!/usr/bin/env bash

if [ -z "$INFLUX_USER" ]; then
  echo "INFLUX_USER not set";
  exit 1;
elif [ -z "$INFLUX_PASSWORD" ]; then
  echo "$INFLUX_PASSWORD not set";
  exit 1;
elif [ -z "$INFLUX_BASE_URL" ]; then
  echo "$INFLUX_BASE_URL not set";
  exit 1;
elif [ -z "$INFLUX_DB" ]; then
  echo "$INFLUX_DB not set";
  exit 1;
fi

while true; do
  for int in $(ls -1d /sys/class/net/{bb*,bat*,wg*} 2>/dev/null); do
    echo 'bbstat,interface="'$(basename $int)\
'",node="'$(hostname)'"'\
' '\
'rx-bytes='$(cat $int/statistics/rx_bytes)\
',tx_bytes='$(cat $int/statistics/tx_bytes)\
',rx_packets='$(cat $int/statistics/rx_packets)\
',tx_packets='$(cat $int/statistics/tx_packets)\
' '\
$(date +%s);
  done | curl -s -u "$INFLUX_USER:$INFLUX_PASSWORD" -X POST "$INFLUX_BASE_URL/write?db=$INFLUX_DB&precision=s" --data-binary @-
  sleep 10
done