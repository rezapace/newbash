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
    for dep in zip fzf pv; do
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

# Fungsi untuk memilih direktori menggunakan fzf
select_directory() {
    local selected_directory
    selected_directory=$(find . -type d | fzf --prompt="Select directory to ZIP: " --height=40% --border)
    echo "$selected_directory"
}

# Fungsi untuk memilih tingkat kompresi
select_compression_level() {
    local levels=("0 - No Compression" "1 - Fastest" "2" "3" "4" "5 - Default" "6" "7" "8" "9 - Maximum Compression")
    local selected_level=$(printf "%s\n" "${levels[@]}" | fzf --prompt="Select compression level: " --height=40% --border)
    echo "$selected_level"
}

# Fungsi untuk memasukkan kata sandi
prompt_for_password() {
    local password
    read -s "password?Enter ZIP password: "
    echo "$password"
}

# Fungsi untuk memilih apakah menggunakan password atau tidak
select_password_option() {
    local options=("Yes" "No")
    local selected_option=$(printf "%s\n" "${options[@]}" | fzf --prompt="Use password for ZIP? " --height=20% --border)
    echo "$selected_option"
}

# Fungsi utama untuk membuat arsip ZIP dari direktori yang dipilih dengan opsi enkripsi dan kompresi
create_zip() {
    local selected_directory=$1
    local compression_level=$2
    local use_password=$3
    local zip_name="${selected_directory##*/}.zip"
    local password_option=""
    
    if [[ "$use_password" == "Yes" ]]; then
        local password=$(prompt_for_password)
        password_option="-P $password"
    fi
    
    local compression_number=$(echo "$compression_level" | awk '{print $1}')
    
    debug_log "Creating ZIP archive $zip_name from directory $selected_directory with compression level $compression_number and password option: $use_password"
    
    local start_time=$(date +%s)
    
    # Command to zip with pv progress indicator
    (cd "$selected_directory" && find . -type f | pv -l -s $(find . -type f | wc -l) | zip -$compression_number -r $password_option "../$zip_name" -@ >/dev/null)
    
    local end_time=$(date +%s)
    local elapsed_time=$(( end_time - start_time ))
    
    if [[ $? -eq 0 ]]; then
        echo "ZIP archive $zip_name created successfully."
        echo "Completed in $elapsed_time seconds."
    else
        echo "Failed to create ZIP archive."
    fi
}

# Fungsi utama
main() {
    check_dependencies

    local selected_directory=$(select_directory)
    if [[ -n "$selected_directory" ]]; then
        local compression_level=$(select_compression_level)
        if [[ -n "$compression_level" ]]; then
            local use_password=$(select_password_option)
            if [[ -n "$use_password" ]]; then
                create_zip "$selected_directory" "$compression_level" "$use_password"
            else
                echo "No password option selected. Exiting."
            fi
        else
            echo "No compression level selected. Exiting."
        fi
    else
        echo "No directory selected. Exiting."
    fi
}

# Eksekusi fungsi utama
main
