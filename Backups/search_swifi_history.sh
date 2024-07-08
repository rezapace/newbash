#!/bin/bash

# Fungsi untuk mencari perintah yang dimulai dengan "swifi" dalam riwayat Zsh
search_swifi_history() {
    # Define the history file location
    HISTFILE=~/.zsh_history

    # Search for commands that start with "swifi" in the history file
    grep -E '^: [0-9]+:[0-9;]+;swifi' "$HISTFILE" | awk -F';' '{print $2}' | fzf --prompt="Select a command: " --height=20% --border
}

# Panggil fungsi untuk mencari history
search_swifi_history
