#!/bin/sh

ssh -i /var/homebridge/id_rsa -o StrictHostKeyChecking=no admin@192.168.21.51 '/data/etc/enabledual.sh &> /dev/null'
touch /var/tmp/indoorcamera.state
