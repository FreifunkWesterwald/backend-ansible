#!/usr/bin/env bash

if ! wg show "$1" 2>&1 >/dev/null; then
  echo "invalid interface $1"
  exit 1
elif [ -z "$INFLUX_USER" ]; then
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
  wg show "$1" dump | \
    tail -n +2 | \
    cut -d$'\t' -f 4,6,7 | \
    sed -E 's/(.*)\/[0-9]+\t(.*)\t(.*)/linkstat,peer="\1",gw="'$(hostname)'" rx-bytes=\2,tx-bytes=\3 '$(date +%s)'/' | \
    curl -s -u "$INFLUX_USER:$INFLUX_PASSWORD" -X POST "$INFLUX_BASE_URL/write?db=$INFLUX_DB&precision=s" --data-binary @-
  sleep 10
done