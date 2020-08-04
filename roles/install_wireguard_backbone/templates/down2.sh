#!/bin/bash
ip -4 rule del iif bb{{ item.name }} table ffww
ip -6 rule del iif bb{{ item.name }} table ffww
ip -4 rule del from all iif bb{{ item.name }} type unreachable
ip -6 rule del from all iif bb{{ item.name }} type unreachable
ip link set down dev bb{{ item.name }}
ip link del bb{{ item.name }}
