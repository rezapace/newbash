#!/bin/bash

# Definisikan fungsi swifi
swifi() {
  local SSID=$1 PASSWORD=$2
  [[ -z "$SSID" || -z "$PASSWORD" ]] && { echo "Usage: swifi <SSID> <PASSWORD>"; return 1; }
  nmcli device wifi connect "$SSID" password "$PASSWORD" && echo "Connected to $SSID successfully." || echo "Failed to connect to $SSID."
}

# Fungsi untuk mencari perintah yang dimulai dengan "swifi" dalam riwayat Zsh
search_swifi_history() {
    # Define the history file location
    HISTFILE=~/.zsh_history

    # Search for commands that start with "swifi" in the history file
    selected_command=$(grep -E '^: [0-9]+:[0-9;]+;swifi' "$HISTFILE" | awk -F';' '{print $2}' | fzf --prompt="Select a command: " --height=20% --border)

    # If a command was selected, execute it
    if [[ -n "$selected_command" ]]; then
        eval "$selected_command"
    else
        echo "No command selected."
    fi
}

# Panggil fungsi untuk mencari history
search_swifi_history
