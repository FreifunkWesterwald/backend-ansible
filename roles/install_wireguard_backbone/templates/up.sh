#!/bin/bash
ip link add bb{{ hostvars[item]['wireguard_bb_name'] }} type wireguard
wg setconf bb{{ hostvars[item]['wireguard_bb_name'] }} /etc/wireguard/wgbb{{ hostvars[item]['wireguard_bb_name'] }}.conf
ip addr add {{ wireguard_bb_ipv6 }}/64 dev bb{{ hostvars[item]['wireguard_bb_name'] }}
ip addr add {{ wireguard_bb_ipv4 }}/32 peer {{ hostvars[item]['wireguard_bb_ipv4'] }}/32 dev bb{{ hostvars[item]['wireguard_bb_name'] }}
ip link set up dev bb{{ hostvars[item]['wireguard_bb_name'] }}
ip -4 rule add from all iif bb{{ hostvars[item]['wireguard_bb_name'] }} table ffww priority 10
ip -6 rule add from all iif bb{{ hostvars[item]['wireguard_bb_name'] }} table ffww priority 10
ip -4 rule add from all iif bb{{ hostvars[item]['wireguard_bb_name'] }} type unreachable priority 200
ip -6 rule add from all iif bb{{ hostvars[item]['wireguard_bb_name'] }} type unreachable priority 200
{% if 'uplink' in group_names %}
ip -4 route add {{hostvars[item]['wireguard_bb_ipv4'] }}/32 dev bb{{ hostvars[item]['wireguard_bb_name'] }} table ffww
{% endif %}
