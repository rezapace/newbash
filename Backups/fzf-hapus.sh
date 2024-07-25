#!/bin/zsh

# Fungsi untuk debug logging
debug_log() {
    if [[ "$DEBUG" = true ]]; then
        echo "DEBUG: $1" >&2
    fi
}

# Fungsi untuk memeriksa apakah suatu perintah ada
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Fungsi untuk memeriksa ketergantungan yang diperlukan
check_dependencies() {
    local missing_deps=()
    for dep in fzf; do
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

# Fungsi untuk memilih file atau direktori menggunakan fzf
select_item() {
    local selected_item
    selected_item=$(find . -mindepth 1 | fzf --prompt="Select file or directory to delete: " --height=40% --border)
    echo "$selected_item"
}

# Fungsi untuk konfirmasi penghapusan menggunakan fzf
confirm_deletion() {
    local item=$1
    local options=("yes" "no")
    local confirmation
    confirmation=$(printf "%s\n" "${options[@]}" | fzf --prompt="Are you sure you want to delete '$item'? " --height=20% --border)
    echo "$confirmation"
}

# Fungsi utama untuk menghapus file atau direktori yang dipilih
delete_item() {
    local selected_item=$1
    if [[ -e "$selected_item" ]]; then
        local confirmation=$(confirm_deletion "$selected_item")
        if [[ "$confirmation" == "yes" ]]; then
            debug_log "Deleting item: $selected_item"
            if rm -rf "$selected_item"; then
                echo "Item '$selected_item' deleted successfully."
            else
                echo "Failed to delete item '$selected_item'."
            fi
        else
            echo "Deletion cancelled."
        fi
    else
        echo "Selected item does not exist."
    fi
}

# Fungsi utama
main() {
    check_dependencies

    local selected_item=$(select_item)
    if [[ -n "$selected_item" ]]; then
        delete_item "$selected_item"
    else
        echo "No file or directory selected. Exiting."
    fi
}

# Eksekusi fungsi utama
main
