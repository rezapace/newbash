#!/bin/zsh

# Function to display file management menu and select action
file_menu() {
    echo -e "1. Copy File\n2. Move File\n3. Exit" | fzf --prompt="Select File Action: " --height=20% --border
}

# Function to copy a file
copy_file() {
    local src=$(find "${1:-.}" -type f 2>/dev/null | fzf --height=40% --layout=reverse --border)
    if [[ -n "$src" ]]; then
        local dest=$(find /home/r -type d 2>/dev/null | fzf --height=40% --layout=reverse --border)
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
        local dest=$(find /home/r -type d 2>/dev/null | fzf --height=40% --layout=reverse --border)
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
    action=$(file_menu)

    case "$action" in
        "1. Copy File")
            copy_file
            ;;
        "2. Move File")
            move_file
            ;;
        "3. Exit")
            echo "Exiting program."
            exit 0
            ;;
        *)
            echo "Invalid action selected. Returning to file management menu."
            ;;
    esac
done

