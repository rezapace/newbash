#!/bin/zsh

# Function to display main menu and select action
main_menu() {
    echo -e "1. Manage Running Tasks\n2. Manage Packages\n3. Copy/Move Files\n4. Exit" | fzf --prompt="Select Action: " --height=20% --border
}

# Function to manage running tasks
manage_running_tasks() {
    local options=("Kill Process" "View Process Details" "Back")
    local action=$(printf "%s\n" "${options[@]}" | fzf --prompt="Select Task Action: " --height=20% --border)

    case "$action" in
        "Kill Process")
            kill_process
            ;;
        "View Process Details")
            view_process_details
            ;;
        "Back")
            echo "Returning to main menu."
            ;;
        *)
            echo "Invalid action selected. Returning to task management menu."
            ;;
    esac
}

# Function to kill a process
kill_process() {
    local process=$(ps -ef | fzf --prompt="Select Process to Kill: " --height=40% --layout=reverse --border | awk '{print $2}')
    if [[ -n "$process" ]]; then
        kill -9 "$process"
        echo "Killed process ID: $process"
    else
        echo "No process selected. Returning to task management menu."
    fi
}

# Function to view process details
view_process_details() {
    local process=$(ps -ef | fzf --prompt="Select Process to View: " --height=40% --layout=reverse --border)
    if [[ -n "$process" ]]; then
        echo "$process" | less
    else
        echo "No process selected. Returning to task management menu."
    fi
}

# Function to manage packages using apt
manage_packages() {
    local options=("Install Package" "Remove Package" "Update Package List" "Upgrade Packages" "Back")
    local action=$(printf "%s\n" "${options[@]}" | fzf --prompt="Select Package Action: " --height=20% --border)

    case "$action" in
        "Install Package")
            install_package
            ;;
        "Remove Package")
            remove_package
            ;;
        "Update Package List")
            update_package_list
            ;;
        "Upgrade Packages")
            upgrade_packages
            ;;
        "Back")
            echo "Returning to main menu."
            ;;
        *)
            echo "Invalid action selected. Returning to package management menu."
            ;;
    esac
}

# Function to install a package
install_package() {
    local package=$(apt-cache search . | awk '{print $1}' | fzf --prompt="Select Package to Install: " --height=40% --layout=reverse --border)
    if [[ -n "$package" ]]; then
        sudo apt-get install "$package"
    else
        echo "No package selected. Returning to package management menu."
    fi
}

# Function to remove a package
remove_package() {
    local package=$(dpkg --get-selections | awk '{print $1}' | fzf --prompt="Select Package to Remove: " --height=40% --layout=reverse --border)
    if [[ -n "$package" ]]; then
        sudo apt-get remove "$package"
    else
        echo "No package selected. Returning to package management menu."
    fi
}

# Function to update package list
update_package_list() {
    sudo apt-get update
    echo "Package list updated."
}

# Function to upgrade packages
upgrade_packages() {
    sudo apt-get upgrade
    echo "Packages upgraded."
}

# Function to copy or move files
copy_move_files() {
    local options=("Copy File" "Move File" "Back")
    local action=$(printf "%s\n" "${options[@]}" | fzf --prompt="Select File Action: " --height=20% --border)

    case "$action" in
        "Copy File")
            copy_file
            ;;
        "Move File")
            move_file
            ;;
        "Back")
            echo "Returning to main menu."
            ;;
        *)
            echo "Invalid action selected. Returning to file management menu."
            ;;
    esac
}

# Function to copy a file
copy_file() {
    local src=$(find "${1:-.}" -type f 2>/dev/null | fzf --height=40% --layout=reverse --border)
    if [[ -n "$src" ]]; then
        local dest=$(find "${1:-.}" -type d 2>/dev/null | fzf --height=40% --layout=reverse --border)
        if [[ -n "$dest" ]]; then
            cp "$src" "$dest"
            echo "Copied $src to $dest"
        else
            echo "No destination selected. Returning to file management menu."
        fi
    else
        echo "No file selected. Returning to file management menu."
    fi
}

# Function to move a file
move_file() {
    local src=$(find "${1:-.}" -type f 2>/dev/null | fzf --height=40% --layout=reverse --border)
    if [[ -n "$src" ]]; then
        local dest=$(find "${1:-.}" -type d 2>/dev/null | fzf --height=40% --layout=reverse --border)
        if [[ -n "$dest" ]]; then
            mv "$src" "$dest"
            echo "Moved $src to $dest"
        else
            echo "No destination selected. Returning to file management menu."
        fi
    else
        echo "No file selected. Returning to file management menu."
    fi
}

# Main script logic
while true; do
    action=$(main_menu)

    case "$action" in
        "1. Manage Running Tasks")
            manage_running_tasks
            ;;
        "2. Manage Packages")
            manage_packages
            ;;
        "3. Copy/Move Files")
            copy_move_files
            ;;
        "4. Exit")
            echo "Exiting program."
            exit 0
            ;;
        *)
            echo "Invalid action selected. Returning to main menu."
            ;;
    esac
done
