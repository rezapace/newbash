#!/bin/bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf could not be found, please install it first."
    exit 1
fi

# Function to export a Docker container
export_docker_container() {
    container=$(docker ps -a --format '{{.Names}}' | fzf --prompt="Select Docker container to export: " --height=20% --border)
    if [ -n "$container" ]; then
        read -p "Enter output file name (without extension): " output
        docker export -o "${output}.tar" "$container"
        echo "Docker container $container has been exported to ${output}.tar."
    else
        echo "No container selected."
    fi
}

# Run the function
export_docker_container
