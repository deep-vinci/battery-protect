#!/bin/bash

export DISPLAY=":1"  
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

batteryPercentage=$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $2}' | sed 's/%//')
batteryStatus=$(upower -i $(upower -e | grep 'BAT') | grep -E "state" | awk '{print $2}' | sed 's/%//')
upperThresholdPercentage=80

CONTROL_FILE="$HOME/battery-enable"

# Check if notifications are enabled
if [ ! -f "$CONTROL_FILE" ]; then
    exit 0
fi

if [ "$batteryStatus" == "charging" ]; then
    if [ $batteryPercentage -ge $upperThresholdPercentage ]; then
        echo "$(date)" > log.txt
        /usr/bin/notify-send "Remove Charger" "Battery $batteryPercentage% Charged." --icon="$HOME/Documents/stupid-scripts/battery-protect/danger-logo.png"  --urgency="critical" --app-name="Battery Protect"
    fi
fi
