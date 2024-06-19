#!/bin/bash

# Advanced startup and shutdown optimization script for Linux Mint Mate

# Function to display messages
echo_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

echo_warn() {
    echo -e "\e[33m[WARN]\e[0m $1"
}

echo_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# Function to check the last command status and exit if there was an error
check_status() {
    if [ $1 -ne 0 ]; then
        echo_error "$2"
        exit 1
    fi
}

# Function to create backup of configuration files
backup_file() {
    local file_path=$1
    if [ -f "$file_path" ]; then
        local backup_path="${file_path}.bak_$(date +%Y%m%d%H%M%S)"
        cp "$file_path" "$backup_path"
        check_status $? "Failed to create backup for $file_path."
        echo_info "Backup created at $backup_path."
    fi
}

# Check if the script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo_error "This script must be run as root."
        exit 1
    fi
}

# Disable unnecessary services in parallel
disable_services() {
    echo_info "Disabling unnecessary services..."
    local services=(
        "cups-browsed"
        "ModemManager"
    )
    for service in "${services[@]}"; do
        systemctl list-unit-files | grep -qw "$service.service" && {
            systemctl is-active --quiet "$service" && {
                systemctl disable "$service" &
                systemctl stop "$service" &
                wait
                check_status $? "Failed to disable $service service."
                echo_info "$service service disabled and stopped."
            } || echo_warn "$service service is already inactive."
        } || echo_warn "$service service does not exist."
    done
}

# Parallel execution of initramfs and grub optimization
optimize_initramfs_and_grub() {
    echo_info "Optimizing initramfs and GRUB in parallel..."
    local initramfs_conf="/etc/initramfs-tools/initramfs.conf"
    local grub_conf="/etc/default/grub"
    
    # Background task for initramfs optimization
    (
        backup_file "$initramfs_conf"
        if grep -q '^MODULES=most' "$initramfs_conf"; then
            sed -i 's/^MODULES=most/MODULES=dep/' "$initramfs_conf"
            check_status $? "Failed to modify initramfs configuration."
            update-initramfs -u
            check_status $? "Failed to update initramfs."
            echo_info "initramfs optimized."
        else
            echo_warn "initramfs is already set to 'dep'."
        fi
    ) &

    # Background task for GRUB optimization
    (
        backup_file "$grub_conf"
        if grep -q '^GRUB_TIMEOUT=' "$grub_conf"; then
            sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' "$grub_conf"
            check_status $? "Failed to modify GRUB timeout."
            update-grub
            check_status $? "Failed to update grub."
            echo_info "GRUB timeout reduced."
        else
            echo_error "Could not find GRUB_TIMEOUT setting."
        fi
    ) &
    wait
}

# Parallel execution for other optimizations
execute_parallel_optimizations() {
    local sysctl_conf="/etc/sysctl.conf"
    local systemd_conf="/etc/systemd/system.conf"
    local journal_conf="/etc/systemd/journald.conf"
    
    # Swappiness
    (
        backup_file "$sysctl_conf"
        if ! grep -q 'vm.swappiness=10' "$sysctl_conf"; then
            echo 'vm.swappiness=10' >> "$sysctl_conf"
            check_status $? "Failed to set swappiness."
            sysctl -p
            check_status $? "Failed to reload sysctl."
            echo_info "Swappiness set to 10."
        else
            echo_warn "Swappiness is already set to 10."
        fi
    ) &

    # Systemd shutdown
    (
        backup_file "$systemd_conf"
        if ! grep -q '^DefaultTimeoutStopSec=1s' "$systemd_conf"; then
            sed -i 's/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=1s/' "$systemd_conf"
            check_status $? "Failed to set systemd shutdown timeout."
            systemctl daemon-reload
            check_status $? "Failed to reload systemd daemon."
            echo_info "Systemd shutdown timeout set to 1 second."
        else
            echo_warn "Systemd shutdown timeout is already set to 1 second."
        fi
    ) &

    # Systemd journal
    (
        backup_file "$journal_conf"
        sed -i 's/#Storage=auto/Storage=volatile/' "$journal_conf"
        check_status $? "Failed to configure journald."
        systemctl restart systemd-journald
        check_status $? "Failed to restart systemd-journald."
        echo_info "Systemd journal set to volatile."
    ) &
    wait
}

# Main function to run all optimizations
main() {
    check_root
    disable_services
    optimize_initramfs_and_grub
    add_preload
    execute_parallel_optimizations
    clean_temp_files
    disable_hibernate_suspend

    echo_info "Optimization complete. Please restart your system to see the changes."
}

main
