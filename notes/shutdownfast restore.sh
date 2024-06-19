#!/bin/bash

# Revert optimizations script for Linux Mint Mate

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

# Function to restore backups of configuration files
restore_backup() {
    local file_path=$1
    local latest_backup=$(ls -t "${file_path}".bak_* | head -1)  # Finds the most recent backup
    if [ -f "$latest_backup" ]; then
        cp -p "$latest_backup" "$file_path" && echo_info "Restored $file_path from backup." || {
            echo_error "Failed to restore $file_path from backup."
            return 1
        }
    else
        echo_warn "No backup found for $file_path."
    fi
}

# Re-enable disabled services
enable_services() {
    echo_info "Re-enabling services..."
    local services=("cups-browsed" "ModemManager")
    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -qw "$service.service"; then
            systemctl is-enabled --quiet "$service" || {
                systemctl enable "$service"
                systemctl start "$service"
                echo_info "$service service enabled and started."
            } || echo_warn "$service service is already active."
        else
            echo_warn "$service service does not exist."
        fi
    done
}

# Revert initramfs and GRUB configuration
revert_initramfs_and_grub() {
    echo_info "Reverting initramfs and GRUB..."
    restore_backup "/etc/initramfs-tools/initramfs.conf"
    update-initramfs -u
    restore_backup "/etc/default/grub"
    update-grub
}

# Remove preload and revert optimizations
remove_preload() {
    echo_info "Removing preload and reverting changes..."
    systemctl stop preload
    systemctl disable preload
    apt-get remove --purge -y preload
    echo_info "Preload removed."
}

# Revert parallel optimizations
revert_parallel_optimizations() {
    echo_info "Reverting parallel optimizations..."
    restore_backup "/etc/sysctl.conf"
    sysctl -p
    restore_backup "/etc/systemd/system.conf"
    systemctl daemon-reload
    restore_backup "/etc/systemd/journald.conf"
    systemctl restart systemd-journald
}

# Re-enable hibernate and suspend features
enable_hibernate_suspend() {
    echo_info "Enabling hibernate and suspend features..."
    systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
    echo_info "Hibernate and suspend features have been enabled."
}

# Main function to run all reversion tasks
main() {
    if [ "$EUID" -ne 0 ]; then
        echo_error "This script must be run as root."
        exit 1
    fi

    enable_services
    revert_initramfs_and_grub
    remove_preload
    revert_parallel_optimizations
    enable_hibernate_suspend

    echo_info "Reversion complete. Please restart your system to see the changes."
}

main
