#!/bin/bash

# Function to connect to Wi-Fi
connect() {
    local SSID=$1
    local PASSWORD=$2

    # Connect to the specified Wi-Fi network
    nmcli device wifi connect "$SSID" password "$PASSWORD"

    # Check the connection status
    if [ $? -eq 0 ]; then
        echo "Connected to $SSID successfully."
    else
        echo "Failed to connect to $SSID."
    fi
}

# Prompt the user for SSID and Password
read -p "Enter the SSID: " SSID
read -p "Enter the password: " PASSWORD
echo

# Call the connect function
connect "$SSID" "$PASSWORD"
