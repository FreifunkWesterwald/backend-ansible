#!/bin/bash
batctl meshif bat{{ site.name }} if del vx{{ site.name }}
ip link set down dev vx{{ site.name }}
ip link del vx{{ site.name }} type vxlan

