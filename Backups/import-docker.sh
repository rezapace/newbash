#!/bin/bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf could not be found, please install it first."
    exit 1
fi

# Function to import a Docker container
import_docker_container() {
    tar_file=$(find . -name "*.tar" | fzf --prompt="Select tar file to import: " --height=20% --border)
    if [ -n "$tar_file" ]; then
        read -p "Enter name for imported Docker image: " image_name
        docker import "$tar_file" "$image_name"
        echo "Docker image imported as $image_name."
    else
        echo "No tar file selected."
    fi
}

# Run the function
import_docker_container
