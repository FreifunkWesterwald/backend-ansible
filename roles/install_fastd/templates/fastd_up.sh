#!/bin/bash
batctl -m bat{{ site.name }} if add vpn{{ site.name }}
ip link set address {{ all_sites[site.name].fastd.mesh_mac[site.node_number-1]}} dev vpn{{ site.name }}
ip link set up dev $1
batctl -m bat{{ site.name }} gw server 1000000/1000000
batctl -m bat{{ site.name }} it 10000
batctl -m bat{{ site.name }} mm 1
echo 64 > /sys/class/net/bat{{ site.name }}/mesh/hop_penalty
#netctl start bat{{ site.name }}
#ifdown bat{{ site.name }}
ifup bat{{ site.name }}
systemctl restart isc-dhcp-server.service
systemctl restart bind9.service
