#!/bin/zsh

# Fungsi untuk debug logging
debug_log() {
    if [[ "$DEBUG" = true ]]; then
        echo "DEBUG: $1" >&2
    fi
}

# Fungsi untuk memeriksa apakah suatu perintah ada
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Fungsi untuk memeriksa ketergantungan yang diperlukan
check_dependencies() {
    local missing_deps=()
    for dep in fzf google-chrome; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "Error: Missing required dependencies: ${missing_deps[*]}"
        echo "Please install them and try again."
        exit 1
    fi
}

# Fungsi untuk mendapatkan daftar folder tingkat pertama
get_folders() {
    find /var/www/html -mindepth 1 -maxdepth 1 -type d
}

# Fungsi untuk memilih folder menggunakan fzf
select_folder() {
    local folders=$(get_folders)
    local selected_folder=$(echo "$folders" | fzf --prompt="Select folder to open in browser: " --height=40% --border --header="Folders")
    echo "$selected_folder"
}

# Fungsi untuk membuka website menggunakan google-chrome
open_website() {
    local folder=$1
    local folderName=$(basename "$folder")
    local url="http://localhost/$folderName/"
    /usr/bin/google-chrome --new-tab "$url"
}

# Fungsi utama
main() {
    check_dependencies

    local selected_folder=$(select_folder)
    if [[ -n "$selected_folder" ]]; then
        open_website "$selected_folder"
    else
        echo "No folder selected. Exiting."
    fi
}

# Eksekusi fungsi utama
main
