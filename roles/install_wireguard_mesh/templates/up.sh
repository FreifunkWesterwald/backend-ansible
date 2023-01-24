#!/bin/bash
ip -6 link add vx{{ site.name }} type vxlan id {{ all_sites[site.name].wireguard_mesh.vxlan_id }} dstport 8472 local {{ all_sites[site.name].wireguard_mesh.meshaddress[site.node_number-1] }} dev wg{{ site.name }}
ip link set mtu 1280 dev vx{{ site.name }}
ip link set address {{ all_sites[site.name].wireguard_mesh.macaddress[site.node_number-1] }} dev vx{{ site.name }}
ip link set up dev vx{{ site.name }}
batctl meshif bat{{ site.name }} if add vx{{ site.name }}


{% for host in groups['fastd'] %}
{% for remote_site in hostvars[host]['sites'] if remote_site.name == site.name and remote_site.node_number != site.node_number %}
bridge fdb append 00:00:00:00:00:00 dev vx{{ site.name }} dst {{ all_sites[remote_site.name].wireguard_mesh.meshaddress[remote_site.node_number-1] }} via wg{{ site.name }}

{% endfor %}
{% endfor %}


{% for host in groups['map'] %}
bridge fdb append 00:00:00:00:00:00 dev vx{{ site.name }} dst {{ hostvars[host].wireguard.address  }} via wg{{ site.name }}
{% endfor %}


batctl meshif bat{{ site.name }} gw server 1000000/1000000
batctl meshif bat{{ site.name }} it 10000
batctl meshif bat{{ site.name }} mm 1
echo 64 > /sys/class/net/bat{{ site.name }}/mesh/hop_penalty
ifup bat{{ site.name }}
systemctl restart isc-dhcp-server.service
systemctl restart bind9.service