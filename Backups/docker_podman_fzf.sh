#!/bin/bash

# Log function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a /var/log/docker_podman_fzf.log
}

# Menu for fzf
action=$(echo -e "Stop Docker\nStop Podman\nStart Docker\nStart Podman\nStatus Docker\nStatus Podman" | fzf --prompt="Select Action: " --height=20% --border)

# Execute selected action
case "$action" in
    "Stop Docker")
        sudo systemctl stop docker.socket && sudo systemctl stop docker && log "Docker stopped"
        ;;
    "Stop Podman")
        sudo systemctl stop podman && sudo systemctl stop podman.socket && log "Podman stopped"
        ;;
    "Start Docker")
        sudo systemctl start docker.socket && sudo systemctl start docker && log "Docker started" || log "Failed to start Docker"
        ;;
    "Start Podman")
        sudo systemctl start podman && sudo systemctl start podman.socket && log "Podman started" || log "Failed to start Podman"
        ;;
    "Status Docker")
        sudo systemctl status docker
        ;;
    "Status Podman")
        sudo systemctl status podman
        ;;
    *)
        echo "Invalid action selected"
        ;;
esac
