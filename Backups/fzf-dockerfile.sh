#!/bin/zsh

# Fungsi untuk memeriksa apakah suatu perintah ada
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Fungsi untuk memeriksa ketergantungan yang diperlukan
check_dependencies() {
    local missing_deps=()
    for dep in fzf docker; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "Error: Missing required dependencies: ${missing_deps[*]}"
        echo "Please install them and try again."
        exit 1
    fi
}

# Fungsi untuk memilih folder sumber menggunakan fzf
select_source_folder() {
    local selected_folder=$(find /home/r/github -mindepth 1 -maxdepth 1 -type d | fzf --prompt="Select source folder: " --height=40% --border --header="Source Folders")
    echo "$selected_folder"
}

# Fungsi untuk memilih Docker container menggunakan fzf
select_docker_container() {
    local selected_container=$(docker ps --format '{{.Names}}' | fzf --prompt="Select Docker container: " --height=40% --border --header="Docker Containers")
    echo "$selected_container"
}

# Fungsi untuk menyalin folder ke dalam Docker
copy_folder_to_docker() {
    local source_folder=$1
    local docker_container=$2

    if [[ -n "$source_folder" && -n "$docker_container" ]]; then
        docker cp "$source_folder/." "$docker_container:/var/www/html"
        echo "Folder $source_folder has been copied to /var/www/html in Docker container $docker_container."
    else
        echo "No source folder or Docker container selected. Exiting."
        exit 1
    fi
}

# Fungsi utama
main() {
    check_dependencies

    local selected_folder=$(select_source_folder)
    if [[ -z "$selected_folder" ]]; then
        echo "No source folder selected. Exiting."
        exit 1
    fi

    local selected_container=$(select_docker_container)
    if [[ -z "$selected_container" ]]; then
        echo "No Docker container selected. Exiting."
        exit 1
    fi

    copy_folder_to_docker "$selected_folder" "$selected_container"
}

# Eksekusi fungsi utama
main
