#!/bin/sh

#Attempt one
ssh -i /var/homebridge/id_rsa -o StrictHostKeyChecking=no admin@motioneye '/data/etc/enabledual.sh &> /dev/null'
echo 'Indoor Camera coming on' | systemd-cat -p info

#Check for success
counter=0
until nc -z motioneye 8082; do
        echo "Enabling Indoor Camera failed - retrying $counter" | systemd-cat -p warning
        counter=`expr $counter + 1`
        sleep 5
        ssh -i /var/homebridge/id_rsa -o StrictHostKeyChecking=no admin@motioneye '/data/etc/enabledual.sh &> /dev/null'

        if [ $counter -eq 5 ]; then
           break
        fi
done

#Check if attempts failed and log results
if [ $counter -eq 5 ]; then
        echo "Indoor Camera failed after $counter attempts - ABORTED" | systemd-cat -p err
else
        #Update status file
        touch /var/tmp/indoorcamera.state
        echo 'Indoor Camera online' | systemd-cat -p info
fi
