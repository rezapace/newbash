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

# Fungsi untuk memilih proses menggunakan fzf
select_process() {
    local selected_process=$(ps -e -o pid,ppid,comm,%cpu,%mem,etime --sort=-%cpu | fzf --prompt="Select process to kill: " --height=50% --border --header="PID PPID COMMAND %CPU %MEM ELAPSED" --preview="ps -p {1} -o pid,ppid,comm,%cpu,%mem,etime --no-headers" --preview-window=up:5)
    echo "$selected_process"
}

# Fungsi untuk menghentikan proses
kill_process() {
    local process_info=$1
    local pid=$(echo "$process_info" | awk '{print $1}')
    
    debug_log "Killing process $pid"
    kill -9 "$pid"
    
    if [[ $? -eq 0 ]]; then
        echo "Process $pid killed successfully."
    else
        echo "Failed to kill process $pid."
    fi
}

# Fungsi utama
main() {
    check_dependencies

    local selected_process=$(select_process)
    if [[ -n "$selected_process" ]]; then
        kill_process "$selected_process"
    else
        echo "No process selected. Exiting."
    fi
}

# Eksekusi fungsi utama
main
