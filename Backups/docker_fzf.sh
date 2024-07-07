#!/bin/bash

# Function to select and run a Docker image
run_docker() {
    docker images --format '{{.Repository}}:{{.Tag}}' | fzf --prompt="Select Docker Image to Run: " --height=20% --border | xargs -I {} docker run -d {}
}

# Function to exec into a running Docker container
exec_docker() {
    docker ps --format '{{.ID}}: {{.Image}}' | fzf --prompt="Select Running Container: " --height=20% --border | awk -F: '{print $1}' | xargs -I {} docker exec -it {} /bin/bash
}

# Function to stop a running Docker container
stop_docker() {
    docker ps --format '{{.ID}}: {{.Image}}' | fzf --prompt="Select Container to Stop: " --height=20% --border | awk -F: '{print $1}' | xargs -I {} docker stop {}
}

# Main function to select the action
main_menu() {
    echo -e "Run Docker Image\nExec into Running Container\nStop Running Container" | fzf --prompt="Select Action: " --height=20% --border
}

# Select the action and execute the corresponding function
action=$(main_menu)

case "$action" in
    "Run Docker Image")
        run_docker
        ;;
    "Exec into Running Container")
        exec_docker
        ;;
    "Stop Running Container")
        stop_docker
        ;;
    *)
        echo "Invalid action selected"
        exit 1
        ;;
esac
