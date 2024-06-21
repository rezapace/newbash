#!/bin/bash
wmctrl -l | awk '{$3=""; print $0}' | rofi -dmenu -i -p "Windows: " | awk '{print $1}' | xargs wmctrl -ia
