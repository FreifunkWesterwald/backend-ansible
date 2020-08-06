#!/bin/bash
ip link set up dev vpn{{ site.name }}
batctl meshif bat{{ site.name }} if add vpn{{ site.name }}
ip l set up dev bat{{ site.name }}
