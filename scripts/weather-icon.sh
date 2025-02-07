#!/bin/bash

# Fetch weather data in JSON format
weather_data=$(curl -s "https://wttr.in/Kathmandu?format=j1")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tomorrow_day=$(date -d "tomorrow" "+%A")
day_after_tomorrow=$(date -d "+2 days" "+%A")

# Extract weather information from the JSON response
location=$(echo "$weather_data" | jq -r '.nearest_area[0].areaName[0].value')
weather_status=$(echo "$weather_data" | jq -r '.current_condition[0].weatherDesc[0].value')
temperature=$(echo "$weather_data" | jq -r '.current_condition[0].temp_C')

# Extract the weather condition code
weather_code=$(echo "$weather_data" | jq -r '.current_condition[0].weatherCode')

weather_status1=$(echo "$weather_data" | jq -r '.weather[1].hourly[4].weatherDesc[0].value')
weather_status2=$(echo "$weather_data" | jq -r '.weather[2].hourly[4].weatherDesc[0].value')

min_temp=$(echo "$weather_data" | jq -r '.weather[0].mintempC')
max_temp=$(echo "$weather_data" | jq -r '.weather[0].maxtempC')

weather_code1=$(echo "$weather_data" | jq -r '.weather[1].hourly[4].weatherCode')
weather_code2=$(echo "$weather_data" | jq -r '.weather[2].hourly[4].weatherCode')

min_temp1=$(echo "$weather_data" | jq -r '.weather[1].mintempC')
max_temp1=$(echo "$weather_data" | jq -r '.weather[1].maxtempC')

min_temp2=$(echo "$weather_data" | jq -r '.weather[2].mintempC')
max_temp2=$(echo "$weather_data" | jq -r '.weather[2].maxtempC')

# Get the current hour in Kathmandu (UTC+5:45)
current_hour=$(TZ=Asia/Kathmandu date +%-H)

# Determine whether it's day or night (6 AM - 6 PM)
if [[ $current_hour -ge 6 && $current_hour -lt 18 ]]; then
    is_day=true  # Daytime
else
    is_day=false  # Nighttime
fi

# Map weather codes to PNG icons with day/night variants
case $weather_code in
    113) icon=$([[ $is_day == true ]] && echo "clear_day.png" || echo "clear_night.png") ;;
    116) icon=$([[ $is_day == true ]] && echo "partly_cloudy_day.png" || echo "partly_cloudy_night.png") ;;
    176|293|185|263|281) icon=$([[ $is_day == true ]] && echo "light_rain_day.png" || echo "light_rain_night.png") ;;
    119|122) icon="cloudy.png" ;;
    200|386|389|392|395) icon="thunderstorm.png" ;;
    248|260|143) icon="fog.png" ;;
    296|299|302|305|308|353|356|359|182|311|266|284|314|317) icon="rain.png" ;;
    179|182|311|227|230|320|323|326|329|332|335|338|350|368|371|374|377|179|320|362|365) icon="snow.png" ;;
    *) icon="unknown.png" ;;
esac
cp -r $SCRIPT_DIR/.././weather-icon/${icon} ~/.cache/weather-icon.png

case $weather_code1 in
    113) icon="clear_day.png" ;;
    116) icon="partly_cloudy_day.png";;
    176|293|185|263|281) icon="light_rain_day.png" ;;
    119|122) icon="cloudy.png" ;;
    200|386|389|392|395) icon="thunderstorm.png" ;;
    248|260|143) icon="fog.png" ;;
    296|299|302|305|308|353|356|359|182|311|266|284|314|317) icon="rain.png" ;;
    179|182|311|227|230|320|323|326|329|332|335|338|350|368|371|374|377|179|320|362|365) icon="snow.png" ;;
    *) icon="unknown.png" ;;
esac
cp -r $SCRIPT_DIR/../weather-icon/${icon} ~/.cache/weather-icon1.png

case $weather_code2 in
    113) icon="clear_day.png" ;;
    116) icon="partly_cloudy_day.png";;
    176|293|185|263|281) icon="light_rain_day.png" ;;
    119|122) icon="cloudy.png" ;;
    200|386|389|392|395) icon="thunderstorm.png" ;;
    248|260|143) icon="fog.png" ;;
    296|299|302|305|308|353|356|359|182|311|266|284|314|317) icon="rain.png" ;;
    179|182|311|227|230|320|323|326|329|332|335|338|350|368|371|374|377|179|320|362|365) icon="snow.png" ;;
    *) icon="unknown.png" ;;
esac
cp -r $SCRIPT_DIR/../weather-icon/${icon} ~/.cache/weather-icon2.png

# Output the weather info and icon path
echo "$location"
echo "$weather_status"
echo "$temperature °C     $min_temp/$max_temp°C"

echo ""
echo ""
echo ""
echo ""

# Print tomorrow's and day-after-tomorrow's forecast with aligned days
# Print min/max temperature for tomorrow and day after tomorrow
echo "\${font Chinacat:bold:size=12}\${color #FF8C00}$tomorrow_day\${color}\${alignr}\${font Chinacat:bold:size=12}\${color #FF6347}$day_after_tomorrow\${color}\${font}"
echo "\${font Chinacat:size=10}$min_temp1/$max_temp1°C \${alignr}$min_temp2/$max_temp2°C ${font}"
echo "\${font Chinacat:size=10}$weather_status1 \${alignr}$weather_status2\${font}"

