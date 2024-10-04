#!/bin/bash

batteryPercentage=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $2}' | sed 's/%//')
batteryStatus=$(upower -i $(upower -e | grep 'BAT') | grep -E "state" | awk '{print $2}' | sed 's/%//')
upperThresholdPercentage=20

# Path to a file that will control notifications
CONTROL_FILE="$HOME/battery-enable"

# Check if notifications are enabled
if [ ! -f "$CONTROL_FILE" ]; then
    exit 0
fi


if [ "$batteryStatus" == "charging" ]; then

    if [ $batteryPercentage -ge $upperThresholdPercentage ]; then
        notify-send "Remove Charger" "Battery $batteryPercentage% Charged" --app-name="Battery Protect" --expire-time=5000
    fi

fi