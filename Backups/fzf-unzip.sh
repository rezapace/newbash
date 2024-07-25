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
    for dep in fzf unzip tar unrar; do
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

# Fungsi untuk memilih file yang akan diekstrak menggunakan fzf
select_file() {
    local selected_file=$(find . -type f \( -name '*.zip' -o -name '*.tar.gz' -o -name '*.tar' -o -name '*.rar' \) | fzf --prompt="Select file to extract: " --height=40% --border --preview='ls -lh {}')
    echo "$selected_file"
}

# Fungsi untuk memilih direktori tujuan
select_destination() {
    local selected_directory=$(find . -type d | fzf --prompt="Select destination directory: " --height=40% --border)
    echo "$selected_directory"
}

# Fungsi untuk mengekstrak file
extract_file() {
    local file=$1
    local destination=$2

    case "$file" in
        *.zip)
            unzip -q "$file" -d "$destination"
            ;;
        *.tar.gz)
            tar -xzf "$file" -C "$destination"
            ;;
        *.tar)
            tar -xf "$file" -C "$destination"
            ;;
        *.rar)
            unrar x -inul "$file" "$destination"
            ;;
        *)
            echo "Unsupported file format."
            return 1
            ;;
    esac

    if [[ $? -eq 0 ]]; then
        echo "Extraction completed successfully."
    else
        echo "Extraction failed."
    fi
}

# Fungsi utama
main() {
    check_dependencies

    local selected_file=$(select_file)
    if [[ -n "$selected_file" ]]; then
        local selected_directory=$(select_destination)
        if [[ -n "$selected_directory" ]]; then
            extract_file "$selected_file" "$selected_directory"
        else
            echo "No destination directory selected. Exiting."
        fi
    else
        echo "No file selected. Exiting."
    fi
}

# Eksekusi fungsi utama
main
