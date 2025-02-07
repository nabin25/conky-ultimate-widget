#!/bin/bash

# Get RAM usage percentage as integer
ram_usage=$(free -m | awk '/^Mem/ {print int($3/$2*100)}')

# Set color based on RAM usage
if (( ram_usage < 25 )); then
    color="#66CC66"  # Green (less than 25%)
elif (( ram_usage >= 25 && ram_usage < 50 )); then
    color="#FFFF00"  # Yellow (25-50%)
elif (( ram_usage >= 50 && ram_usage < 70 )); then
    color="#FF8000"  # Orange (50-70%)
else
    color="#FF0000"  # Red (greater than 70%)
fi

# Output the Conky commands with the dynamic color and progress bar
echo "\${color $color}\${execbar 10,300 echo '$ram_usage'}"
