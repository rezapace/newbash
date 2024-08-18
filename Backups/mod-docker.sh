#!/bin/bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf could not be found, please install it first."
    exit 1
fi

# Function to execute commands inside a selected Docker container
exec_into_docker_container() {
    container=$(docker ps --format '{{.ID}}: {{.Names}}' | fzf --prompt="Select Docker Container: " --height=20% --border | awk -F: '{print $2}')
    
    if [ -n "$container" ]; then
        echo "Executing commands inside Docker container $container..."
        docker exec -it "$container" bash -c "
            chmod -R 755 /var/www/html
            chown -R www-data:www-data /var/www/html
        "
        if [ $? -eq 0 ]; then
            echo "Commands executed successfully in Docker container $container."
        else
            echo "Failed to execute commands in Docker container $container."
        fi
    else
        echo "No Docker container selected."
    fi
}

# Run the function
exec_into_docker_container
