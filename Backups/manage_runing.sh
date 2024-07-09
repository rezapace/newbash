#!/bin/zsh

# Function to display task management menu and select action
task_menu() {
    echo -e "1. Kill Process\n2. View Process Details\n3. Exit" | fzf --prompt="Select Task Action: " --height=20% --border
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

# Main script logic
while true; do
    action=$(task_menu)

    case "$action" in
        "1. Kill Process")
            kill_process
            ;;
        "2. View Process Details")
            view_process_details
            ;;
        "3. Exit")
            echo "Exiting program."
            exit 0
            ;;
        *)
            echo "Invalid action selected. Returning to task management menu."
            ;;
    esac
done

