#!/bin/bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf could not be found, please install it first."
    exit 1
fi

# Function to run Docker container with selected image
run_docker_container() {
    image=$(docker images --format '{{.Repository}}:{{.Tag}}' | fzf --prompt="Select Docker Image to Run: " --height=20% --border)
    
    if [ -n "$image" ]; then
        read -p "Enter container name: " container_name
        docker run -d -p 3306:3306 -p 8080:80 --name "$container_name" "$image" /bin/bash -c "service apache2 start && service mysql start && tail -f /dev/null"
        if [ $? -eq 0 ]; then
            echo "Docker container $container_name started from image $image."
        else
            echo "Failed to start Docker container from image $image."
        fi
    else
        echo "No Docker image selected."
    fi
}

# Run the function
run_docker_container
