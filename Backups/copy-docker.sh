#!/bin/bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf could not be found, please install it first."
    exit 1
fi

# Function to copy a folder to a Docker container
copy_folder_to_docker() {
    source_folder=$(find /home/r/github -mindepth 1 -maxdepth 1 -type d | fzf --prompt="Select source folder: " --height=40% --border --header="Source Folders")
    container=$(docker ps --format '{{.Names}}' | fzf --prompt="Select Docker container: " --height=40% --border --header="Docker Containers")

    if [[ -n "$source_folder" && -n "$container" ]]; then
        docker cp "$source_folder/." "$container:/var/www/html"
        echo "Folder $source_folder has been copied to /var/www/html in Docker container $container."
    else
        echo "No source folder or Docker container selected. Exiting."
        exit 1
    fi
}

# Run the function
copy_folder_to_docker
