#!/bin/bash

# Start bluetoothctl and disconnect from device
echo -e "disconnect 1C:52:16:C7:B9:9C\nexit" | bluetoothctl
