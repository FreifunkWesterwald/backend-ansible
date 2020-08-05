#!/bin/bash
{% for host in groups['fastd'] %}
{% for remote_site in hostvars[host]['sites'] if remote_site.name == site.name and remote_site.node_number != site.node_number %}
ip link add mesh{{ site.name }}{{ remote_site.node_number }} type ip6gretap remote {{ all_sites[remote_site.name].wireguard_mesh.address[remote_site.node_number-1] }} local {{ all_sites[remote_site.name].wireguard_mesh.address[site.node_number-1] }} ttl 255 dev wg{{ site.name }}
ip link set mtu 1312 dev mesh{{ site.name }}{{ remote_site.node_number }}
ip link set address {{ all_sites[remote_site.name].wireguard_mesh.mac_prefix[site.node_number-1] }}{{ remote_site.node_number }} dev mesh{{ site.name }}{{ remote_site.node_number }}
ip link set up dev mesh{{ site.name }}{{ remote_site.node_number }}
batctl meshif bat{{ site.name }} if add mesh{{ site.name }}{{ remote_site.node_number }}
{% endfor %}
{% endfor %}
batctl meshif bat{{ site.name }} gw server 1000000/1000000
batctl meshif bat{{ site.name }} it 10000
batctl meshif bat{{ site.name }} mm 1
echo 64 > /sys/class/net/bat{{ site.name }}/mesh/hop_penalty
ifup bat{{ site.name }}
#systemctl restart isc-dhcp-server.service
systemctl restart bind9.service
