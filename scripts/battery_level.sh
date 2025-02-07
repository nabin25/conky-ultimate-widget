#!/bin/bash

# Get full charge capacity dynamically (convert µWh to Wh)
full_charge_capacity=$(awk '{print $1 / 1000000}' /sys/class/power_supply/BAT0/energy_full)

# Get current power consumption in watts (if available)
power_watts=$(awk '{print $1 / 1000000}' /sys/class/power_supply/BAT0/power_now)

# Ensure power_watts is not zero before division
if [[ "$power_watts" != "0" && "$power_watts" != "" ]]; then
    if [[ "$(cat /sys/class/power_supply/BAT0/status)" == "Discharging" ]]; then
        remaining_time=$(echo "scale=2; $full_charge_capacity / $power_watts" | bc)
        time_color="\${color #FFD700}"  
        time_label="( $remaining_time hrs \${font DejaVu Sans:size=12}↓\${font} )"
    elif [[ "$(cat /sys/class/power_supply/BAT0/status)" == "Charging" ]]; then
        charge_time=$(echo "scale=2; $full_charge_capacity / $power_watts" | bc)
        time_color="\${color #32CD32}"  
        time_label="( $charge_time hrs\${font DejaVu Sans:size=12}↑\${font} )"
    else
        time_color="\${color #32CD32}"
        time_label="(Charged)"
    fi
else
    time_label="(Unknown)"
    time_color="\${color #FF0000}" 
fi

# Battery percentage
capacity=$(cat /sys/class/power_supply/BAT0/capacity)

# Output battery status
echo "\${color Tan1}Battery \${alignr}\${color1}$capacity% $time_color$time_label\${color}"

# ---- Battery Progress Bar ----
# Determine color based on battery level
if [ "$capacity" -le 10 ]; then
    color="#B20000"  # Dark Red
elif [ "$capacity" -le 30 ]; then
    color="#CC7A00"  # Dark Orange
elif [ "$capacity" -le 50 ]; then
    color="#CCCC00"  # Dark Yellow
elif [ "$capacity" -le 70 ]; then
    color="#7FBFD2"  # Dark Light Blue
elif [ "$capacity" -le 90 ]; then
    color="#66CC66"  # Dark Light Green
else
    color="#00B200"  # Dark Green
fi

# Output the progress bar for Conky
echo "\${color $color}\${execbar 10,300 echo $capacity}"

