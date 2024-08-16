#!/bin/bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf could not be found, please install it first."
    exit 1
fi

# Function to remove Docker container with selected ID
remove_docker_container() {
    container_id=$(docker ps -a --format '{{.ID}}: {{.Names}} ({{.Image}})' | fzf --prompt="Select Docker Container to Remove: " --height=20% --border | awk -F: '{print $1}')
    
    if [ -n "$container_id" ]; then
        docker container rm -f "$container_id"
        if [ $? -eq 0 ]; then
            echo "Docker container $container_id has been removed."
        else
            echo "Failed to remove Docker container $container_id."
        fi
    else
        echo "No Docker container selected."
    fi
}

# Run the function
remove_docker_container
