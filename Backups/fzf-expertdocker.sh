#!/bin/bash

# Enhanced error handling and logging
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT

LOG_FILE="/var/log/docker_script.log"
ERROR_LOG_FILE="/var/log/docker_script_error.log"
CONFIG_FILE="$HOME/.docker_script_config"

log_message() { printf "%s: %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$1" | tee -a "$LOG_FILE"; }
log_error() { printf "%s: ERROR: %s\n" "$(date +"%Y-%m-%d %H:%M:%S")" "$1" | tee -a "$ERROR_LOG_FILE"; }

handle_error() {
    local exit_code=$1
    local error_message=$2
    if [[ $exit_code -ne 0 ]]; then
        log_error "$error_message"
        return 1
    fi
}

# Dependency checking
check_dependencies() {
    local deps=("fzf" "docker" "jq" "docker-compose" "openssl" "curl" "rsync" "trivy")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Error: $dep is not installed. Please install it and try again." >&2
            if [ "$dep" == "trivy" ]; then
                echo "To install trivy, you can use the following commands:"
                echo "curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin"
            fi
            exit 1
        fi
    done
}

# Docker service management functions
manage_docker_service() {
    local action=$1
    sudo systemctl "$action" docker
    handle_error $? "Failed to $action Docker service."
    log_message "Docker service $action successfully."
}

start_docker() { manage_docker_service "start"; }
stop_docker() { manage_docker_service "stop"; }
restart_docker() { manage_docker_service "restart"; }
enable_docker() { manage_docker_service "enable"; }
disable_docker() { manage_docker_service "disable"; }

status_docker() {
    local status
    status=$(sudo systemctl status docker)
    handle_error $? "Failed to retrieve Docker status."
    echo "$status"
}

# Advanced Docker operations
advanced_run_docker() {
    local image=$(docker images --format '{{.Repository}}:{{.Tag}}' | fzf --prompt="Select Docker Image to Run: " --height=40% --border)
    [[ -z "$image" ]] && { log_message "No Docker image selected."; return 0; }
    
    local options=()
    while true; do
        local option=$(echo -e "name\nport\nvolume\nenv\nnetwork\nrestart\nmemory\ncpu\nuser\nworkdir\ncommand\nfinish" | fzf --prompt="Select option to add (or finish): " --height=40% --border)
        case "$option" in
            name) read -p "Enter container name: " name; options+=("--name $name") ;;
            port) read -p "Enter port mapping: " port; options+=("-p $port") ;;
            volume) read -p "Enter volume mapping: " volume; options+=("-v $volume") ;;
            env) read -p "Enter environment variable: " env; options+=("-e $env") ;;
            network) read -p "Enter network: " network; options+=("--network $network") ;;
            restart) read -p "Enter restart policy: " restart; options+=("--restart $restart") ;;
            memory) read -p "Enter memory limit: " memory; options+=("--memory $memory") ;;
            cpu) read -p "Enter CPU limit: " cpu; options+=("--cpus $cpu") ;;
            user) read -p "Enter user: " user; options+=("--user $user") ;;
            workdir) read -p "Enter working directory: " workdir; options+=("--workdir $workdir") ;;
            command) read -p "Enter command: " cmd; options+=("$cmd") ;;
            finish) break ;;
        esac
    done
    
    docker run -d "${options[@]}" "$image"
    handle_error $? "Failed to start Docker container from image $image."
    log_message "Docker container started from image $image with options: ${options[*]}"
}

# System monitoring and resource management
monitor_docker_resources() {
    local interval=5
    while true; do
        clear
        echo "Docker Resource Usage (Ctrl+C to exit)"
        echo "======================================"
        docker stats --no-stream
        sleep $interval
    done
}

# Security features
secure_docker() {
    echo "Securing Docker installation..."
    
    # Enable user namespace remapping
    echo '{"userns-remap": "default"}' | sudo tee /etc/docker/daemon.json
    
    # Restrict network traffic
    sudo ufw default deny incoming
    sudo ufw allow ssh
    sudo ufw allow 2376/tcp
    sudo ufw enable
    
    # Enable Docker Content Trust
    export DOCKER_CONTENT_TRUST=1
    
    # Audit Docker daemon
    sudo auditctl -w /usr/bin/docker -k docker
    
    restart_docker
    log_message "Docker security enhancements applied."
}

# Backup and restore functionality
backup_docker() {
    local backup_dir="/var/backups/docker"
    local date_stamp=$(date +"%Y%m%d_%H%M%S")
    local backup_file="${backup_dir}/docker_backup_${date_stamp}.tar.gz"
    
    sudo mkdir -p "$backup_dir"
    sudo docker run --rm -v /var/lib/docker:/var/lib/docker -v "$backup_dir":/backup alpine tar czf "/backup/$(basename "$backup_file")" /var/lib/docker
    
    handle_error $? "Failed to create Docker backup."
    log_message "Docker backup created: $backup_file"
}

restore_docker() {
    local backup_dir="/var/backups/docker"
    local backup_file=$(ls -1 "$backup_dir" | fzf --prompt="Select backup to restore: " --height=40% --border)
    [[ -z "$backup_file" ]] && { log_message "No backup selected."; return 0; }
    
    stop_docker
    sudo rm -rf /var/lib/docker
    sudo tar xzf "${backup_dir}/${backup_file}" -C /
    start_docker
    
    handle_error $? "Failed to restore Docker from backup."
    log_message "Docker restored from backup: $backup_file"
}

# Remote Docker management
manage_remote_docker() {
    local remote_host=$(load_config "remote_docker_host")
    if [[ -z "$remote_host" ]]; then
        read -p "Enter remote Docker host (e.g., user@hostname): " remote_host
        save_config "remote_docker_host" "$remote_host"
    fi
    
    local action=$(echo -e "list\nstart\nstop\nrestart\nstatus" | fzf --prompt="Select remote action: " --height=40% --border)
    [[ -z "$action" ]] && { log_message "No remote action selected."; return 0; }
    
    case "$action" in
        list) ssh "$remote_host" docker ps -a ;;
        start|stop|restart) ssh "$remote_host" sudo systemctl "$action" docker ;;
        status) ssh "$remote_host" sudo systemctl status docker ;;
    esac
    
    handle_error $? "Failed to perform remote Docker action: $action"
    log_message "Remote Docker action completed: $action"
}

# Custom script integration
manage_custom_scripts() {
    local scripts_dir="$HOME/.docker_custom_scripts"
    mkdir -p "$scripts_dir"
    
    local action=$(echo -e "list\ncreate\nedit\ndelete\nrun" | fzf --prompt="Select custom script action: " --height=40% --border)
    [[ -z "$action" ]] && { log_message "No custom script action selected."; return 0; }
    
    case "$action" in
        list)
            ls -1 "$scripts_dir"
            ;;
        create)
            read -p "Enter new script name: " script_name
            $EDITOR "${scripts_dir}/${script_name}"
            chmod +x "${scripts_dir}/${script_name}"
            ;;
        edit)
            local script=$(ls -1 "$scripts_dir" | fzf --prompt="Select script to edit: " --height=40% --border)
            [[ -z "$script" ]] && return 0
            $EDITOR "${scripts_dir}/${script}"
            ;;
        delete)
            local script=$(ls -1 "$scripts_dir" | fzf --prompt="Select script to delete: " --height=40% --border)
            [[ -z "$script" ]] && return 0
            rm "${scripts_dir}/${script}"
            ;;
        run)
            local script=$(ls -1 "$scripts_dir" | fzf --prompt="Select script to run: " --height=40% --border)
            [[ -z "$script" ]] && return 0
            "${scripts_dir}/${script}"
            ;;
    esac
    
    handle_error $? "Failed to $action custom script."
    log_message "Custom script action completed: $action"
}

# Advanced networking features
advanced_network_management() {
    local action=$(echo -e "create\nremove\nlist\nconnect\ndisconnect\ninspect\noverlap" | fzf --prompt="Select network action: " --height=40% --border)
    [[ -z "$action" ]] && { log_message "No network action selected."; return 0; }
    
    case "$action" in
        create)
            local name
            read -p "Enter network name: " name
            local driver=$(echo -e "bridge\nhost\noverlay\nmacvlan\nnone" | fzf --prompt="Select network driver: " --height=40% --border)
            [[ -z "$driver" ]] && return 0
            docker network create --driver "$driver" "$name"
            ;;
        remove)
            local network=$(docker network ls --format '{{.Name}}' | fzf --prompt="Select network to remove: " --height=40% --border)
            [[ -z "$network" ]] && return 0
            docker network rm "$network"
            ;;
        list)
            docker network ls
            ;;
        connect|disconnect)
            local network=$(docker network ls --format '{{.Name}}' | fzf --prompt="Select network: " --height=40% --border)
            [[ -z "$network" ]] && return 0
            local container=$(docker ps --format '{{.ID}}: {{.Names}}' | fzf --prompt="Select container: " --height=40% --border | awk -F: '{print $1}')
            [[ -z "$container" ]] && return 0
            docker network "$action" "$network" "$container"
            ;;
        inspect)
            local network=$(docker network ls --format '{{.Name}}' | fzf --prompt="Select network to inspect: " --height=40% --border)
            [[ -z "$network" ]] && return 0
            docker network inspect "$network"
            ;;
        overlap)
            docker network inspect $(docker network ls -q) | jq -r '.[].IPAM.Config[].Subnet' | sort | uniq -d
            ;;
    esac
    handle_error $? "Failed to $action Docker network."
    log_message "Docker network $action completed successfully."
}

# Container orchestration
manage_docker_compose() {
    local compose_file
    read -p "Enter path to docker-compose.yml file: " compose_file
    [[ ! -f "$compose_file" ]] && { log_error "docker-compose.yml not found at $compose_file"; return 1; }
    
    local action=$(echo -e "up\ndown\nstart\nstop\nrestart\nlogs\nps\nexec\nconfig" | fzf --prompt="Select docker-compose action: " --height=40% --border)
    [[ -z "$action" ]] && { log_message "No action selected."; return 0; }
    
    case "$action" in
        up|down|start|stop|restart)
            docker-compose -f "$compose_file" "$action" -d
            ;;
        logs)
            docker-compose -f "$compose_file" logs -f
            ;;
        ps)
            docker-compose -f "$compose_file" ps
            ;;
        exec)
            local service=$(docker-compose -f "$compose_file" ps --services | fzf --prompt="Select service: " --height=40% --border)
            [[ -z "$service" ]] && return 0
            read -p "Enter command to execute: " cmd
            docker-compose -f "$compose_file" exec "$service" $cmd
            ;;
        config)
            docker-compose -f "$compose_file" config
            ;;
    esac
    handle_error $? "Failed to execute docker-compose $action."
    log_message "docker-compose $action executed successfully."
}

# Performance tuning
tune_docker_performance() {
    echo "Tuning Docker performance..."
    
    # Adjust Docker daemon settings
    echo '{
        "storage-driver": "overlay2",
        "log-driver": "json-file",
        "log-opts": {
            "max-size": "10m",
            "max-file": "3"
        },
        "max-concurrent-downloads": 10,
        "max-concurrent-uploads": 10
    }' | sudo tee /etc/docker/daemon.json
    
    # Adjust kernel parameters
    echo "
    net.ipv4.ip_forward=1
    net.bridge.bridge-nf-call-iptables=1
    net.ipv4.conf.all.forwarding=1
    " | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    
    restart_docker
    log_message "Docker performance tuning applied."
}

# Docker image scanning
scan_docker_image() {
    local image=$(docker images --format '{{.Repository}}:{{.Tag}}' | fzf --prompt="Select Docker Image to Scan: " --height=40% --border)
    [[ -z "$image" ]] && { log_message "No Docker image selected."; return 0; }
    
    # Using Trivy for vulnerability scanning (you need to install Trivy first)
    trivy image "$image"
    handle_error $? "Failed to scan Docker image $image."
    log_message "Docker image $image scanned successfully."
}

# Docker benchmark security
benchmark_docker_security() {
    # Using Docker Bench Security (you need to install it first)
    docker run --rm -it --net host --pid host --userns host --cap-add audit_control \
        -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
        -v /var/lib:/var/lib \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /usr/lib/systemd:/usr/lib/systemd \
        -v /etc:/etc --label docker_bench_security \
        docker/docker-bench-security
    handle_error $? "Failed to run Docker Bench Security."
    log_message "Docker Bench Security completed successfully."
}

# Docker stress testing
stress_test_docker() {
    local container_name="stress_test_container"
    local stress_image="progrium/stress"
    
    echo "Running stress test on Docker..."
    docker run --rm --name "$container_name" -d "$stress_image" --cpu 2 --io 1 --vm 2 --vm-bytes 128M --timeout 30s
    
    echo "Monitoring container resource usage during stress test..."
    docker stats --no-stream "$container_name"
    
    docker wait "$container_name"
    handle_error $? "Stress test failed."
    log_message "Docker stress test completed successfully."
}

# Docker container health check
check_container_health() {
    local container=$(docker ps --format '{{.Names}}' | fzf --prompt="Select container to check health: " --height=40% --border)
    [[ -z "$container" ]] && { log_message "No container selected."; return 0; }
    
    local health_status=$(docker inspect --format='{{.State.Health.Status}}' "$container")
    echo "Health status of $container: $health_status"
    
    if [[ "$health_status" == "unhealthy" ]]; then
        echo "Container is unhealthy. Last 5 health check logs:"
        docker inspect --format='{{range $i, $h := .State.Health.Log}}{{if lt $i 5}}{{$h.Output}}{{end}}{{end}}' "$container"
    fi
    
    handle_error $? "Failed to check container health."
    log_message "Container health check completed for $container."
}

# Docker network diagnostics
diagnose_docker_network() {
    local container=$(docker ps --format '{{.Names}}' | fzf --prompt="Select container for network diagnostics: " --height=40% --border)
    [[ -z "$container" ]] && { log_message "No container selected."; return 0; }
    
    echo "Running network diagnostics for $container..."
    docker exec "$container" sh -c "ping -c 4 8.8.8.8 && nslookup google.com && curl -I https://www.docker.com"
    
    handle_error $? "Network diagnostics failed for $container."
    log_message "Network diagnostics completed for $container."
}

# Docker layer analysis
analyze_docker_layers() {
    local image=$(docker images --format '{{.Repository}}:{{.Tag}}' | fzf --prompt="Select Docker Image to analyze layers: " --height=40% --border)
    [[ -z "$image" ]] && { log_message "No Docker image selected."; return 0; }
    
    docker history --no-trunc --format "table {{.CreatedBy}}\t{{.Size}}" "$image"
    
    handle_error $? "Failed to analyze layers for Docker image $image."
    log_message "Layer analysis completed for Docker image $image."
}

# Configuration management
save_config() {
    local key=$1
    local value=$2
    jq --arg key "$key" --arg value "$value" '.[$key] = $value' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    handle_error $? "Failed to save configuration."
}

load_config() {
    local key=$1
    jq -r ".$key // empty" "$CONFIG_FILE"
}

manage_config() {
    local action=$(echo -e "view\nset\ndelete" | fzf --prompt="Select config action: " --height=40% --border)
    [[ -z "$action" ]] && { log_message "No config action selected."; return 0; }
    
    case "$action" in
        view)
            cat "$CONFIG_FILE"
            ;;
        set)
            local key value
            read -p "Enter config key: " key
            read -p "Enter config value: " value
            save_config "$key" "$value"
            ;;
        delete)
            local key=$(jq -r 'keys[]' "$CONFIG_FILE" | fzf --prompt="Select key to delete: " --height=40% --border)
            [[ -z "$key" ]] && return 0
            jq "del(.$key)" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
            ;;
    esac
    handle_error $? "Failed to $action configuration."
    log_message "Configuration $action completed successfully."
}

# Main menu function
main_menu() {
    echo -e "Docker Management System\n========================\n
Docker Service:
1. Start Docker
2. Stop Docker
3. Restart Docker
4. Check Docker Status
5. Enable Docker on Boot
6. Disable Docker on Boot

Container and Image Management:
7. Advanced Run Docker Image
8. Exec into Running Container
9. Stop Running Container
10. Remove Docker Container
11. Remove Docker Image
12. View Container Logs
13. List All Containers
14. List All Images
15. Prune Docker Resources
16. Show Docker Disk Usage

Advanced Operations:
17. Build Docker Image
18. Manage Docker Compose
19. Advanced Network Management
20. Volume Management
21. Manage Configuration

System and Security:
22. Monitor Docker Resources
23. Secure Docker Installation
24. Backup Docker
25. Restore Docker
26. Manage Remote Docker
27. Manage Custom Scripts
28. Tune Docker Performance

Advanced Security and Diagnostics:
29. Scan Docker Image
30. Benchmark Docker Security
31. Stress Test Docker
32. Check Container Health
33. Diagnose Docker Network
34. Analyze Docker Image Layers

0. Exit" | fzf --prompt="Select Action: " --height=80% --border
}

# Main function
main() {
    check_dependencies
    
    while true; do
        local action=$(main_menu)
        [[ -z "$action" ]] && { echo "No action selected. Exiting."; break; }
        
        case "$action" in
            "1. Start Docker") start_docker ;;
            "2. Stop Docker") stop_docker ;;
            "3. Restart Docker") restart_docker ;;
            "4. Check Docker Status") status_docker ;;
            "5. Enable Docker on Boot") enable_docker ;;
            "6. Disable Docker on Boot") disable_docker ;;
            "7. Advanced Run Docker Image") advanced_run_docker ;;
            "8. Exec into Running Container") exec_docker ;;
            "9. Stop Running Container") stop_running_docker ;;
            "10. Remove Docker Container") remove_container ;;
            "11. Remove Docker Image") remove_image ;;
            "12. View Container Logs") logs_docker ;;
            "13. List All Containers") list_containers ;;
            "14. List All Images") list_images ;;
            "15. Prune Docker Resources") prune_docker ;;
            "16. Show Docker Disk Usage") disk_usage_docker ;;
            "17. Build Docker Image") build_image ;;
            "18. Manage Docker Compose") manage_docker_compose ;;
            "19. Advanced Network Management") advanced_network_management ;;
            "20. Volume Management") volume_management ;;
            "21. Manage Configuration") manage_config ;;
            "22. Monitor Docker Resources") monitor_docker_resources ;;
            "23. Secure Docker Installation") secure_docker ;;
            "24. Backup Docker") backup_docker ;;
            "25. Restore Docker") restore_docker ;;
            "26. Manage Remote Docker") manage_remote_docker ;;
            "27. Manage Custom Scripts") manage_custom_scripts ;;
            "28. Tune Docker Performance") tune_docker_performance ;;
            "29. Scan Docker Image") scan_docker_image ;;
            "30. Benchmark Docker Security") benchmark_docker_security ;;
            "31. Stress Test Docker") stress_test_docker ;;
            "32. Check Container Health") check_container_health ;;
            "33. Diagnose Docker Network") diagnose_docker_network ;;
            "34. Analyze Docker Image Layers") analyze_docker_layers ;;
            "0. Exit") echo "Exiting."; exit 0 ;;
            *) log_error "Invalid action selected." ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

# Initialize config file if it doesn't exist
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo '{}' > "$CONFIG_FILE"
    if [[ $? -ne 0 ]]; then
        log_error "Failed to initialize configuration file."
        exit 1
    fi
    log_message "Configuration file initialized."
fi

# Run main function
main
