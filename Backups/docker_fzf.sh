#!/bin/bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "fzf could not be found, please install it first."
    exit 1
fi

# Function to start Docker
start_docker() {
    sudo systemctl start docker
    if [ $? -eq 0 ]; then
        echo "Docker started."
    else
        echo "Failed to start Docker."
    fi
}

# Function to stop Docker
stop_docker() {
    sudo systemctl stop docker.socket
    sudo systemctl disable docker.socket
    sudo systemctl stop docker
    sudo systemctl disable docker
    if [ $? -eq 0 ]; then
        echo "Docker stopped and disabled."
    else
        echo "Failed to stop and disable Docker."
    fi
}

# Function to restart Docker
restart_docker() {
    sudo systemctl restart docker
    if [ $? -eq 0 ]; then
        echo "Docker restarted."
    else
        echo "Failed to restart Docker."
    fi
}

# Function to check Docker status
status_docker() {
    sudo systemctl status docker
}

# Function to enable Docker to start on boot
enable_docker() {
    sudo systemctl enable docker
    sudo systemctl enable docker.socket
    if [ $? -eq 0 ]; then
        echo "Docker enabled to start on boot."
    else
        echo "Failed to enable Docker on boot."
    fi
}

# Function to disable Docker from starting on boot
disable_docker() {
    sudo systemctl disable docker
    sudo systemctl disable docker.socket
    if [ $? -eq 0 ]; then
        echo "Docker disabled from starting on boot."
    else
        echo "Failed to disable Docker on boot."
    fi
}

# Function to select and run a Docker image
run_docker() {
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

# Function to exec into a running Docker container
exec_docker() {
    container=$(docker ps --format '{{.ID}}: {{.Image}}' | fzf --prompt="Select Running Container: " --height=20% --border | awk -F: '{print $1}')
    if [ -n "$container" ]; then
        docker exec -it $container /bin/bash
    else
        echo "No running container selected."
    fi
}

# Function to stop a running Docker container
stop_running_docker() {
    container=$(docker ps --format '{{.ID}}: {{.Image}}' | fzf --prompt="Select Container to Stop: " --height=20% --border | awk -F: '{print $1}')
    if [ -n "$container" ]; then
        docker stop $container
        if [ $? -eq 0 ]; then
            echo "Docker container $container stopped."
        else
            echo "Failed to stop Docker container $container."
        fi
    else
        echo "No running container selected."
    fi
}

# Function to remove a Docker container
remove_container() {
    container=$(docker ps -a --format '{{.ID}}: {{.Image}}' | fzf --prompt="Select Container to Remove: " --height=20% --border | awk -F: '{print $1}')
    if [ -n "$container" ]; then
        docker rm $container
        if [ $? -eq 0 ]; then
            echo "Docker container $container removed."
        else
            echo "Failed to remove Docker container $container."
        fi
    else
        echo "No container selected."
    fi
}

# Function to remove a Docker image
remove_image() {
    image=$(docker images --format '{{.Repository}}:{{.Tag}}' | fzf --prompt="Select Image to Remove: " --height=20% --border)
    if [ -n "$image" ]; then
        docker rmi $image
        if [ $? -eq 0 ]; then
            echo "Docker image $image removed."
        else
            echo "Failed to remove Docker image $image."
        fi
    else
        echo "No Docker image selected."
    fi
}

# Function to view logs of a running Docker container
logs_docker() {
    container=$(docker ps --format '{{.ID}}: {{.Image}}' | fzf --prompt="Select Container to View Logs: " --height=20% --border | awk -F: '{print $1}')
    if [ -n "$container" ]; then
        docker logs -f $container
    else
        echo "No running container selected."
    fi
}

# Function to list all Docker containers
list_containers() {
    docker ps -a
}

# Function to list all Docker images
list_images() {
    docker images
}

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

# Main function to select the action
main_menu() {
    echo -e "Start Docker\nStop Docker\nRestart Docker\nCheck Docker Status\nEnable Docker on Boot\nDisable Docker on Boot\nRun Docker Image\nExec into Running Container\nStop Running Container\nRemove Docker Container\nRemove Docker Image\nView Container Logs\nList All Containers\nList All Images\nCopy Folder to Docker\nExport Docker Container\nImport Docker Container" | fzf --prompt="Select Action: " --height=20% --border
}

# Select the action and execute the corresponding function
action=$(main_menu)

case "$action" in
    "Start Docker")
        start_docker
        ;;
    "Stop Docker")
        stop_docker
        ;;
    "Restart Docker")
        restart_docker
        ;;
    "Check Docker Status")
        status_docker
        ;;
    "Enable Docker on Boot")
        enable_docker
        ;;
    "Disable Docker on Boot")
        disable_docker
        ;;
    "Run Docker Image")
        run_docker
        ;;
    "Exec into Running Container")
        exec_docker
        ;;
    "Stop Running Container")
        stop_running_docker
        ;;
    "Remove Docker Container")
        remove_container
        ;;
    "Remove Docker Image")
        remove_image
        ;;
    "View Container Logs")
        logs_docker
        ;;
    "List All Containers")
        list_containers
        ;;
    "List All Images")
        list_images
        ;;
    "Copy Folder to Docker")
        copy_folder_to_docker
        ;;
    "Export Docker Container")
        export_docker_container
        ;;
    "Import Docker Container")
        import_docker_container
        ;;
    *)
        echo "Invalid action selected"
        exit 1
        ;;
esac
