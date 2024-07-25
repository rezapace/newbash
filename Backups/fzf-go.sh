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
    for dep in fzf go; do
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

# Fungsi untuk memilih file Go menggunakan fzf
select_go_file() {
    local selected_file=$(find . -type f -name '*.go' | fzf --prompt="Select Go file: " --height=40% --border --preview='cat {}')
    echo "$selected_file"
}

# Fungsi untuk memilih tindakan (run, build, dll.) menggunakan fzf
select_action() {
    local actions=("Run" "Build" "Test" "Fmt" "Vet" "Install")
    local selected_action=$(printf "%s\n" "${actions[@]}" | fzf --prompt="Select action: " --height=20% --border)
    echo "$selected_action"
}

# Fungsi untuk menjalankan program Go
run_go_program() {
    local go_file=$1
    debug_log "Running Go program $go_file"
    go run "$go_file"
    
    if [[ $? -eq 0 ]]; then
        echo "Go program executed successfully."
    else
        echo "Failed to execute Go program."
    fi
}

# Fungsi untuk membangun program Go
build_go_program() {
    local go_file=$1
    debug_log "Building Go program $go_file"
    go build "$go_file"
    
    if [[ $? -eq 0 ]]; then
        echo "Go program built successfully."
    else
        echo "Failed to build Go program."
    fi
}

# Fungsi untuk menguji program Go
test_go_program() {
    local go_file=$1
    debug_log "Testing Go program $go_file"
    go test "${go_file%/*}"  # Running tests in the directory containing the selected file
    
    if [[ $? -eq 0 ]]; then
        echo "Go tests executed successfully."
    else
        echo "Failed to execute Go tests."
    fi
}

# Fungsi untuk memformat kode Go
fmt_go_program() {
    local go_file=$1
    debug_log "Formatting Go code $go_file"
    go fmt "$go_file"
    
    if [[ $? -eq 0 ]]; then
        echo "Go code formatted successfully."
    else
        echo "Failed to format Go code."
    fi
}

# Fungsi untuk memeriksa kode Go
vet_go_program() {
    local go_file=$1
    debug_log "Vetting Go code $go_file"
    go vet "$go_file"
    
    if [[ $? -eq 0 ]]; then
        echo "Go code vetted successfully."
    else
        echo "Failed to vet Go code."
    fi
}

# Fungsi untuk menginstal program Go
install_go_program() {
    local go_file=$1
    debug_log "Installing Go program $go_file"
    go install "${go_file%/*}"  # Installing the package containing the selected file
    
    if [[ $? -eq 0 ]]; then
        echo "Go program installed successfully."
    else
        echo "Failed to install Go program."
    fi
}

# Fungsi utama
main() {
    check_dependencies

    local selected_file=$(select_go_file)
    if [[ -n "$selected_file" ]]; then
        local selected_action=$(select_action)
        if [[ -n "$selected_action" ]]; then
            case "$selected_action" in
                "Run")
                    run_go_program "$selected_file"
                    ;;
                "Build")
                    build_go_program "$selected_file"
                    ;;
                "Test")
                    test_go_program "$selected_file"
                    ;;
                "Fmt")
                    fmt_go_program "$selected_file"
                    ;;
                "Vet")
                    vet_go_program "$selected_file"
                    ;;
                "Install")
                    install_go_program "$selected_file"
                    ;;
                *)
                    echo "Unsupported action selected."
                    ;;
            esac
        else
            echo "No action selected. Exiting."
        fi
    else
        echo "No Go file selected. Exiting."
    fi
}

# Eksekusi fungsi utama
main
