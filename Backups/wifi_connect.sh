#!/bin/zsh

# File to store WiFi passwords
WIFI_PASSWORD_FILE="$HOME/.wifi_passwords"

# Enable debugging
DEBUG=true

# Function for debug logging
debug_log() {
    if [[ "$DEBUG" = true ]]; then
        echo "DEBUG: $1" >&2
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check for required dependencies
check_dependencies() {
    local missing_deps=()
    for dep in nmcli fzf; do
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

# Function to search and select WiFi SSID from a list
select_wifi() {
    local selected_wifi
    selected_wifi=$(nmcli device wifi list | tail -n +2 | fzf --prompt="Select WiFi SSID: " --height=40% --border | awk '{print $2}')
    echo "$selected_wifi"
}

# Function to get stored password
get_stored_password() {
    local ssid=$1
    if [[ -f "$WIFI_PASSWORD_FILE" ]]; then
        local stored_password=$(grep "^$ssid:" "$WIFI_PASSWORD_FILE" | cut -d':' -f2)
        debug_log "Retrieved stored password for $ssid: ${stored_password:0:3}***"
        echo "$stored_password"
    else
        debug_log "Password file not found"
    fi
}

# Function to store password
store_password() {
    local ssid=$1
    local password=$2
    debug_log "Storing password for $ssid: ${password:0:3}***"
    sed -i.bak "/^$ssid:/d" "$WIFI_PASSWORD_FILE" 2>/dev/null || true
    echo "$ssid:$password" >> "$WIFI_PASSWORD_FILE"
    debug_log "Password stored successfully"
}

# Function to remove stored password
remove_stored_password() {
    local ssid=$1
    debug_log "Removing stored password for $ssid"
    if [[ -f "$WIFI_PASSWORD_FILE" ]]; then
        sed -i.bak "/^$ssid:/d" "$WIFI_PASSWORD_FILE" 2>/dev/null || true
        debug_log "Password removed successfully"
    else
        debug_log "Password file not found, nothing to remove"
    fi
}

# Function to connect to selected WiFi
connect_wifi() {
    local selected_wifi=$1
    local stored_password=$(get_stored_password "$selected_wifi")
    local password
    local retry=true

    while $retry; do
        if [[ -n "$stored_password" ]]; then
            echo "Using stored password for $selected_wifi"
            password=$stored_password
        else
            password=$(prompt_for_password)
            if [[ -z "$password" ]]; then
                echo "Error: Password is empty."
                return 1
            fi
        fi
        
        debug_log "Attempting to connect to $selected_wifi"
        if nmcli device wifi connect "$selected_wifi" password "$password"; then
            echo "Connected to $selected_wifi successfully."
            if [[ -z "$stored_password" ]]; then
                store_password "$selected_wifi" "$password"
                echo "Password stored for future use."
            fi
            retry=false
        else
            echo "Failed to connect to $selected_wifi."
            if [[ -n "$stored_password" ]]; then
                echo "Stored password might be incorrect. Removing stored password."
                remove_stored_password "$selected_wifi"
                stored_password=""
                echo "Please enter the password manually."
            else
                read "retry_choice?Do you want to try again? (y/n): "
                if [[ $retry_choice != "y" && $retry_choice != "Y" ]]; then
                    retry=false
                fi
            fi
        fi
    done
}

# Function to prompt for WiFi password visibly
prompt_for_password() {
    local password
    read "password?Enter WiFi password (visible): "
    debug_log "Password entered: ${password:0:3}***"
    echo "$password"
}

# Main menu function
main_menu() {
    local choice
    local options=("Select WiFi to Connect" "Exit")
    
    while true; do
        echo "\nWiFi Connection Menu"
        echo "-------------------"
        choice=$(printf '%s\n' "${options[@]}" | fzf --prompt="Select an option: " --height=20% --border)

        case "$choice" in
            "Select WiFi to Connect")
                local selected_wifi=$(select_wifi)
                if [[ -n "$selected_wifi" ]]; then
                    connect_wifi "$selected_wifi"
                else
                    echo "No WiFi SSID selected. Returning to main menu."
                fi
                ;;
            "Exit")
                echo "Exiting program."
                exit 0
                ;;
            *)
                echo "Invalid choice or no selection made. Please try again."
                ;;
        esac
    done
}

# Main execution
main() {
    check_dependencies
    trap 'echo "\nInterrupted. Exiting program."; exit 1' INT

    main_menu
}

main
