#!/usr/bin/env sh

if ! echo "$1" | grep -E '^ww[0-9]+$' >/dev/null; then
  echo invalid bridge name >&2
  exit 1
fi

BRIDGE=$1
STALE_AGE=3600
STALE_DB=./stale_keys_$BRIDGE.db

if [ ! -f $STALE_DB ]; then
  touch $STALE_DB
  chmod 640 $STALE_DB
fi

wg show wg$BRIDGE dump | tail -n +2 | tr '\t' ';' | cut '-d;' -f 1,3,5 | (
  IFS=';'
  while read WG_PUBKEY ENDPOINT LAST_HEATBEAT; do
    NOW=$(date +%s)
    AGO=$(( $NOW - $LAST_HEATBEAT ))
    if [ $AGO -gt $STALE_AGE ]; then
      echo -n "Key '$WG_PUBKEY' was last seen from '$ENDPOINT' ${AGO}s ago."
      if ! grep "$WG_WG_PUBKEY" $STALE_DB >/dev/null; then
        echo " Marking key as stale."
        echo $WG_PUBKEY >> $STALE_DB
      else
        echo " Key is known stale key. Removing..."
        MACADDR="$(echo "$WG_PUBKEY" | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/')"
        # calculate link-local address using EUI-64 method (7th bit inverted -> static '02' converts to '00' and is thus omitted.
        IPV6="$(echo "$MACADDR" | sed 's/^\(..\):\(..\):\(..\):\(..\):\(..\):\(..\)$/fe80::\2:\3ff:fe\4:\5\6/')"
        wg set "wg$BRIDGE" peer "$WG_PUBKEY" remove
        bridge fdb del 00:00:00:00:00:00 dev "vx$BRIDGE" dst "$IPV6" via "wg$BRIDGE"
        grep -v "$WG_PUBKEY" > $STALE_DB.~
        mv $STALE_DB.~ $STALE_DB
      fi
    fi
  done
)