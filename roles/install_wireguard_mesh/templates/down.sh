#!/bin/bash
{% for host in groups['fastd'] %}
{% for remote_site in hostvars[host]['sites'] if remote_site.name == site.name and remote_site.node_number != site.node_number %}
batctl meshif bat{{ site.name }} if del mesh{{ site.name }}{{ remote_site.node_number }}
ip link set down dev mesh{{ site.name }}{{ remote_site.node_number }}
ip link del mesh{{ site.name }}{{ remote_site.node_number }} type ip6gretap
{% endfor %}
{% endfor %}
