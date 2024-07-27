#!/bin/zsh

# File riwayat Zsh
HISTFILE="$HOME/.zsh_history"

# Fungsi untuk debug logging
debug_log() {
    echo "DEBUG: $1" >&2
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

# Fungsi untuk mengambil direktori dari file riwayat Zsh
extract_directories_from_history() {
    if [[ -f "$HISTFILE" ]]; then
        debug_log "Reading from HISTFILE: $HISTFILE"
        debug_log "Contents of HISTFILE (first 10 lines):"
        head -n 10 "$HISTFILE" >&2  # Show first few lines for debugging
        # Membaca file riwayat Zsh dan mengekstrak perintah 'cd' dari baris yang sesuai
        local dirs=$(tac "$HISTFILE" | grep -E ';cd ' | awk -F';' '{print $2}' | awk '{print $2}' | grep '^/' | uniq | head -n 5)
        debug_log "Extracted directories: $dirs"
        echo "$dirs"
    else
        debug_log "HISTFILE does not exist: $HISTFILE"
        echo ""
    fi
}

# Fungsi untuk memilih direktori dari riwayat menggunakan fzf
select_directory() {
    local directories=$(extract_directories_from_history)
    debug_log "Directories extracted: $directories"
    
    if [[ -n "$directories" ]]; then
        debug_log "Launching fzf with directories"
        local selected_directory=$(echo "$directories" | fzf --prompt="Select directory to go back to: " --height=40% --border --header="Recent directories")
        debug_log "Directory selected: $selected_directory"
        echo "$selected_directory"
    else
        debug_log "No directories found in history"
        echo ""
    fi
}

# Fungsi untuk berpindah ke direktori yang dipilih
change_directory() {
    local directory=$1
    debug_log "Changing to directory: $directory"
    
    if [[ -d "$directory" ]]; then
        cd "$directory" || return 1
        echo "Changed directory to $directory"
    else
        echo "Directory $directory does not exist"
        return 1
    fi
}

# Fungsi utama untuk berpindah ke direktori dari riwayat
jump_to_directory() {
    check_dependencies
    
    debug_log "Extracting and selecting directory"
    local selected_directory=$(select_directory)
    
    if [[ -n "$selected_directory" ]]; then
        change_directory "$selected_directory"
    else
        echo "No directory selected. Exiting."
    fi
}

# Alias untuk fungsi utama
alias balik=jump_to_directory

# Eksekusi fungsi utama hanya jika dipanggil langsung
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    jump_to_directory
fi
