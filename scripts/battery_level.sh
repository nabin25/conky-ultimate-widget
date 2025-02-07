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

# Output for Conky
echo "\${color Tan1}Battery \${alignr}\${color1}$(cat /sys/class/power_supply/BAT0/capacity)% $time_color$time_label\${color}"

