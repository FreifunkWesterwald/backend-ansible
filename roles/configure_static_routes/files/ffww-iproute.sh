#!/bin/bash
#Alles, was mit 0x1 markiert wird gehört zu Tabelle ffww
ip -4 rule add from all fwmark 0x1 table ffww priority 10
ip -6 rule add from all fwmark 0x1 table ffww priority 10

#Alles mit Freifunk-IP - woher auch immer - gehört zu Tabelle ffww
ip -4 rule add to 10.30.0.0/18 table ffww priority 10
ip -4 rule add to 10.222.1.0/24 table ffww priority 10
ip -4 rule add to 10.222.2.0/23 table ffww priority 10
ip -4 rule add to 10.222.4.0/22 table ffww priority 10
ip -4 rule add to 10.222.8.0/21 table ffww priority 10
ip -4 rule add to 10.222.16.0/20 table ffww priority 10
ip -4 rule add to 10.222.32.0/19 table ffww priority 10
ip -4 rule add to 10.222.64.0/18 table ffww priority 10
ip -4 rule add to 10.222.128.0/17 table ffww priority 10
ip -6 rule add to 2001:470:cd45:ff00::/56 table ffww priority 10
ip -6 rule add to 2a03:2260:1016::/48 table ffww priority 10
ip -6 rule add to 64:ff9b::/96 table ffww priority 10
ip -6 rule add to fd62:44e1:da::/48 table ffww priority 10

