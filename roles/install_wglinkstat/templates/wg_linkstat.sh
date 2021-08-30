#!/usr/bin/env bash
if ! wg show "$1" 2>&1 >/dev/null; then
  "invalid interface $1"
  exit 1
fi
while true; do
  wg show "$1" dump | \
    tail -n +2 | \
    cut -d$'\t' -f 4,6,7 | \
    sed -E 's/(.*)\/[0-9]+\t(.*)\t(.*)/linkstat,peer="\1",gw="'$(hostname)'" rx-bytes=\2,tx-bytes=\3 '$(date +%s)'/' | \
    curl -s -X POST 'https://influx.freifunk-westerwald.de/write?db=ffww&precision=s&u={{ hostvars['ffww-map'].influx.username }}&p={{ hostvars['ffww-map'].influx.password }}' --data-binary @-
  sleep 10
done