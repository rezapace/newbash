#!/bin/zsh

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> ~/.zsh_log
}

# Function to control XAMPP services using fzf
xampp_control() {
    local services=("apache2" "mysql")
    local actions=("start" "stop" "restart" "status")
    
    # Prompt user to select an action using fzf
    local action=$(printf "%s\n" "${actions[@]}" | fzf --prompt="Select action: " --height=10% --border)
    
    if [[ -z "$action" ]]; then
        echo "No action selected. Exiting."
        return 1
    fi
    
    local action_capitalized=$(echo "${action:0:1}" | tr 'a-z' 'A-Z')${action:1}
    echo "${action_capitalized}ing XAMPP services..."
    
    for service in "${services[@]}"; do
        if sudo service "$service" "$action"; then
            log "XAMPP service $service ${action}ed"
        else
            log "Failed to ${action} XAMPP service $service"
        fi
    done
}

# Call the xampp_control function
xampp_control
