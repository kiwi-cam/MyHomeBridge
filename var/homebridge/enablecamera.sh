#!/bin/sh

ssh -i /var/homebridge/id_rsa -o StrictHostKeyChecking=no admin@motioneye '/data/etc/enabledual.sh &> /dev/null'
touch /var/tmp/indoorcamera.state
