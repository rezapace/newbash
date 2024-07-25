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
    for dep in fzf; do
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

# Fungsi untuk memilih antara file atau folder
select_type() {
    local options=("File" "Folder")
    local selected_option=$(printf "%s\n" "${options[@]}" | fzf --prompt="Select type to search: " --height=20% --border)
    echo "$selected_option"
}

# Fungsi untuk memilih file atau folder menggunakan fzf
select_item() {
    local item_type=$1
    local find_command="find ."
    
    if [[ "$item_type" == "File" ]]; then
        find_command="$find_command -type f"
    else
        find_command="$find_command -type d"
    fi

    local selected_item=$(eval "$find_command" | fzf --prompt="Select $item_type to copy/move: " --height=40% --border)
    echo "$selected_item"
}

# Fungsi untuk memilih tindakan copy atau move
select_action() {
    local options=("Copy" "Move")
    local selected_option=$(printf "%s\n" "${options[@]}" | fzf --prompt="Select action: " --height=20% --border)
    echo "$selected_option"
}

# Fungsi untuk melakukan tindakan copy atau move
perform_action() {
    local item=$1
    local action=$2
    local destination="/var/www/html"
    
    if [[ "$action" == "Copy" ]]; then
        cp -r "$item" "$destination"
    else
        mv "$item" "$destination"
    fi

    if [[ $? -eq 0 ]]; then
        echo "$action completed successfully."
    else
        echo "$action failed."
    fi
}

# Fungsi utama
main() {
    check_dependencies

    local item_type=$(select_type)
    if [[ -n "$item_type" ]]; then
        local selected_item=$(select_item "$item_type")
        if [[ -n "$selected_item" ]]; then
            local action=$(select_action)
            if [[ -n "$action" ]]; then
                perform_action "$selected_item" "$action"
            else
                echo "No action selected. Exiting."
            fi
        else
            echo "No $item_type selected. Exiting."
        fi
    else
        echo "No type selected. Exiting."
    fi
}

# Eksekusi fungsi utama
main
