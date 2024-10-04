#!/bin/bash

batteryPercentage=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $2}' | sed 's/%//')
upperThresholdPercentage=20

if [ $batteryPercentage -ge $upperThresholdPercentage ]; then
    notify-send "Remove Charger" "Battery $batteryPercentage% Charged" --app-name="Battery Protect" --expire-time=5000
fi