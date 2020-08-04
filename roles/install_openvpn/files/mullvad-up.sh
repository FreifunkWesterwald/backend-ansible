#!/bin/bash
#/sbin/ip route replace default via $4 table ffmyk
sleep 3
echo Reroute via $route_vpn_gateway
ip route replace 0.0.0.0/0 via $route_vpn_gateway proto static table ffmyk
#ip -6 route replace default dev $dev proto static table ffmyk

exit 0
