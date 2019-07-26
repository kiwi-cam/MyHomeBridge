#!/bin/sh

ssh -i /var/homebridge/id_rsa -o StrictHostKeyChecking=no admin@motioneye '/data/etc/enablesingle.sh &> /dev/null'
rm -f /var/tmp/indoorcamera.state
echo 'Indoor Camera coming offline' | systemd-cat -p info

#Check for success
counter=0
while nc -z motioneye 8082; do
        echo i"Disabling Indoor Camera failed - retrying ($counter)" | systemd-cat -p warning
        counter=`expr $counter + 1`
        sleep 5
        ssh -i /var/homebridge/id_rsa -o StrictHostKeyChecking=no admin@motioneye '/data/etc/enablesingle.sh &> /dev/null'

        if [ $counter -eq 5 ]; then
           break
        fi
done

#Check if attempts failed and log results
if [ $counter -eq 5 ]; then
        echo "Indoor Camera failed after $counter attempts - ABORTED" | systemd-cat -p err
else
        #Update status file
        rm -f /var/tmp/indoorcamera.state
        echo 'Indoor Camera offline' | systemd-cat -p info
fi
