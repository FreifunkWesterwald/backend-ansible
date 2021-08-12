#!/usr/bin/env bash
# stdout is sent to the client
# stderr is written to service log
echo "handling $SOCAT_PEERADDR:$SOCAT_PEERPORT" >&2

function sanitize {
  echo "$*" | LC_ALL=C tr -d '\0-\37\177-\377'
}

# read and validate domain
read -r -t 5 -n 64 DOMAIN

if [ -z "$DOMAIN" ]; then
  echo ERR: NO_DOMAIN
  echo "client didn't provide domain" >&2
  exit 1
fi

if ! echo "$DOMAIN" | grep '^ffww01$' >/dev/null ; then
  echo ERR: INVALID_DOMAIN
  echo "domain '$(sanitize "$DOMAIN")' is invalid" >&2
  exit 1
fi

#read and validate wg key
read -r -t 5 -n 64 WG_PUBKEY

if [ -z "$WG_PUBKEY" ]; then
  echo ERR: NO_WGKEY
  echo "client didn't provide wireguard key" >&2
  exit 1
fi

if ! echo "$WG_PUBKEY" | grep -E '^[A-Za-z0-9+/]{42}[A|E|I|M|Q|U|Y|c|g|k|o|s|w|4|8|0]=$' >/dev/null ; then
  echo ERR: INVALID_WGKEY
  echo "wireguard key '$(sanitize "$WG_PUBKEY")' is invalid" >&2
  exit 1
fi

if grep "$WG_PUBKEY" /etc/wgkex/disallowed_keys >/dev/null ; then
  echo ERR: PROHIBITED_WGKEY
  echo "wireguard key '$WG_PUBKEY' is contained in disallowed_keys list" >&2
  exit 1
fi

BRIDGE="$(echo "$DOMAIN" | sed 's/^ff//')"
MACADDR="$(echo "$WG_PUBKEY" | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/')"
# calculate link-local address using EUI-64 method (7th bit inverted -> static '02' converts to '00' and is thus omitted.
IPV6="$(echo "$MACADDR" | sed 's/^\(..\):\(..\):\(..\):\(..\):\(..\):\(..\)$/fe80::\2:\3ff:fe\4:\5\6/')"
echo "configuring key '$WG_PUBKEY' to peer '$IPV6' with vxlan mac '$MACADDR'" >&2
# remove peer first, to clear seq-number state
# otherwise the connection might not work, if the clients clock jumped
wg set "wg$BRIDGE" peer "$WG_PUBKEY" remove
wg set "wg$BRIDGE" peer "$WG_PUBKEY" allowed-ips "$IPV6/128"
bridge fdb append 00:00:00:00:00:00 dev "vx$BRIDGE" dst "$IPV6" via "wg$BRIDGE"

exit 0