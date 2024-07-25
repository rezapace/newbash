#!/bin/zsh

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check for required dependencies
check_dependencies() {
    if ! command_exists php; then
        echo "Error: PHP is required but not installed."
        exit 1
    fi
}

# Function to execute Laravel Artisan commands
execute_laravel_command() {
    local choice
    local commands=("php artisan list" "php artisan migrate" "php artisan db:seed" "php artisan route:list" "php artisan config:cache" "php artisan cache:clear" "php artisan serve")

    echo "\nLaravel Artisan Commands"
    echo "------------------------"
    choice=$(printf '%s\n' "${commands[@]}" | fzf --prompt="Select a command to execute: " --height=40% --border)

    case "$choice" in
        "php artisan list")
            php artisan list
            ;;
        "php artisan migrate")
            php artisan migrate
            ;;
        "php artisan db:seed")
            php artisan db:seed
            ;;
        "php artisan route:list")
            php artisan route:list
            ;;
        "php artisan config:cache")
            php artisan config:cache
            ;;
        "php artisan cache:clear")
            php artisan cache:clear
            ;;
        "php artisan serve")
            php artisan serve
            ;;
        *)
            echo "Invalid command or no selection made."
            ;;
    esac
}

# Main menu function
main_menu() {
    local choice
    local options=("Execute Laravel Commands" "Exit")
    
    while true; do
        echo "\nLaravel Command Menu"
        echo "--------------------"
        choice=$(printf '%s\n' "${options[@]}" | fzf --prompt="Select an option: " --height=20% --border)

        case "$choice" in
            "Execute Laravel Commands")
                execute_laravel_command
                ;;
            "Exit")
                echo "Exiting program."
                exit 0
                ;;
            *)
                echo "Invalid choice or no selection made. Please try again."
                ;;
        esac
    done
}

# Main execution
main() {
    check_dependencies
    trap 'echo "\nInterrupted. Exiting program."; exit 1' INT

    main_menu
}

main
