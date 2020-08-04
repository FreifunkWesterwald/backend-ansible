#!/bin/bash
ip link add bb{{ item.name }} type wireguard
wg setconf bb{{ item.name }} /etc/wireguard/wgbb{{ item.name }}.conf
ip addr add {{ wireguard_bb_ipv6 }}/64 dev bb{{ item.name }}
ip addr add {{ wireguard_bb_ipv4 }}/32 peer {{ item.ipv4 }}/32 dev bb{{ item.name }}
ip link set up dev bb{{ item.name }}
ip -4 rule add from all iif bb{{ item.name }} table ffww priority 10
ip -6 rule add from all iif bb{{ item.name }} table ffww priority 10
ip -4 rule add from all iif bb{{ item.name }} type unreachable priority 200
ip -6 rule add from all iif bb{{ item.name }} type unreachable priority 200

