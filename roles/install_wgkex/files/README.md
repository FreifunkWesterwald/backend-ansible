# WG-KEX

This module provides everything necessary for the wireguard key-exchange, i.e., routers providing their wireguard
public key and freifunk domain in some way, so that they can connect.

This key exchange protocol, if it deserves a name like that, simply transfers the clients public-key and domain name via 
an unencrypted TCP connection to the gateway server (a.k.a. supernode). The `wgkex_handler` derives a MAC address from 
the keys MD5 hash and in turn generates a link-local IPv6 address via the EUI-64 method.

The public key is then added to the domains wireguard interface using the generated IPv6 link-local address as allowed
peer IP - which is computed and set by the client device in the same manner. Finally, the MAC address is added to the
vxlan tunnel with the IPv6 link-local address as its destination.

## Security considerations

The process, receiving the wireguard keys should run with the least possible privileges, as it's an internet-facing open
API. This is implemented by a `socat` process, running as a "normal" user, which is privileged to run `wgkex_handler` as
root via sudo.

`wgkex_handler` strictly limits it's input (via STDIN) to two lines of input, with at most 64 symbols each, and a timeout
of 5 seconds per line. Only after strict validation are the inputs passed to the `wg` and `brigde` commands.

## Cleanup

As clients may change wireguard keys, or might otherwise never-connect-again, stale wireguard keys and vxlan entries
should be removed regularly. This is achieved by the `wgkex_cleanup` script, which gets invoked per domain every 15 minutes
via a systemd timer. Keys, that didn't register a wireguard heartbeat for over one hour over two iterations of the 
script are removed.
The "two iterations" thing is needed, as keys, which are freshly added and didn't connect yet, are listed by wireguard 
with a last heartbeat at 1970-01-01Z. Using this, such "fresh" keys are only removed, if they aren't connected with for
at least 15 minutes, after which the client might just rexecute the key exchange as well.

## Notes

The `kex_port` is currently configured on site-level in `wireguard_mesh.kex_port`. As the KEX itself is multi-site / domain
capable, this doesn't really make sense. Maybe the property should be moved to another location.
This would then also allow to clean-up the `sites[0].name` foo in `wgkex-worker.service`