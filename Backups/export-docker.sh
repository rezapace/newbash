#!/bin/bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf could not be found, please install it first."
    exit 1
fi

# Ensure the output directory exists
output_dir="/home/r/docker"
mkdir -p "$output_dir"

# Function to export a Docker container
export_docker_container() {
    container=$(docker ps -a --format '{{.Names}}' | fzf --prompt="Select Docker container to export: " --height=20% --border)
    if [ -n "$container" ]; then
        read -p "Enter output file name (without extension): " output
        docker export -o "${output_dir}/${output}.tar" "$container"
        echo "Docker container $container has been exported to ${output_dir}/${output}.tar."
    else
        echo "No container selected."
    fi
}

# Run the function
export_docker_container
