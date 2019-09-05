# Weather from Trentham Weather station (using META header)
temp=$(wget -q https://wmac.org.nz/trenthamweather -O - | head -n 1 | awk -F 'tmp ' '{print $2}' | awk -F , '{print $1+0}')

if echo $temp | egrep -q '^-*[[:digit:]]+.*[[:digit:]]*$'; then
        echo "Temperature of $temp found from wmac.org.nz"
        echo "$temp" > /var/tmp/upperhutt.txt
else
        # Fall back to weather from Trentham MetService EWS
        temp=$(curl 'https://www.metservice.com/publicData/localObs_upper-hutt' | sed -n '/\"temp\"/p' | sed -E 's/([^0-9]+\.*[^0-9]*)//g')
        if echo $temp | egrep -q '^-*[[:digit:]]+.*[[:digit:]]*$'; then
                echo "Temperature of $temp found from MetService"
                echo "$temp" > /var/tmp/upperhutt.txt
        else
                # Finally fall back to Weather from AccuWeather
                temp=$(curl -L "http://dataservice.accuweather.com/currentconditions/v1/250941?apikey=xxxxxxxxxxxxxxxxxxxxxxxxx" | awk -F "\"Temperature\":{\"Metric\":{\"Value\":" '{print $2}' | awk -F ",\"" '{print $1}')
                if echo $temp | egrep -q '^-*[[:digit:]]+.*[[:digit:]]*$'; then
                        echo "Temperature of $temp found from Accuweather"
                        echo "$temp" > /var/tmp/upperhutt.txt
                else
                        echo "ERROR - No Temperature Found"
                        echo "0" > /var/tmp/upperhutt.txt
                fi
        fi
fi
