#!/bin/sh
nc -z 192.168.21.51 8082

if [ $? -eq 1 ]; then
	#Port is closed
	rm -f /var/tmp/indoorcamera.state
else
	#Port is open
	touch /var/tmp/indoorcamera.state
fi
