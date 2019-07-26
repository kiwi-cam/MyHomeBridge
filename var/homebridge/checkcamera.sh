#!/bin/sh
nc -z motioneye 8082

if [ $? -eq 1 ]; then
        #Port is closed
        if [ -f /var/tmp/indoorcamera.state ]; then
                rm -f /var/tmp/indoorcamera.state
                echo 'Indoor Camera found offline' | systemd-cat -p warning
        fi
else
        #Port is open
        if [ ! -f /var/tmp/indoorcamera.state ]; then
                (umask 0; touch /var/tmp/indoorcamera.state)
                echo 'Indoor Camera found online' | systemd-cat -p warning
        fi
fi
