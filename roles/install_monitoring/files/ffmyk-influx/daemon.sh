#!/bin/bash
cd /opt/ffmyk-influx
while : ;do
	php -c ./php.ini -f dhcp.php
	php -c ./php.ini -f traffic.php
	php -c ./php.ini -f fastd.php
	sleep 15
done
