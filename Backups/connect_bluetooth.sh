#!/bin/bash

# Start bluetoothctl and connect to device
echo -e "connect 1C:52:16:C7:B9:9C\nexit" | bluetoothctl
