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

# Function to check the last command status and handle errors
check_status() {
    if [ $1 -ne 0 ]; then
        echo_error "$2"
        exit 1
    fi
}

# Function to create a backup of configuration files
backup_file() {
    local file_path=$1
    if [ -f "$file_path" ]; then
        local backup_path="${file_path}.bak_$(date +%Y%m%d%H%M%S)"
        cp -p "$file_path" "$backup_path" && echo_info "Backup created at $backup_path." || {
            echo_error "Failed to create backup for $file_path."
            return 1
        }
    else
        echo_warn "$file_path does not exist. Backup not needed."
    fi
}

# Check if the script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo_error "This script must be run as root."
        exit 1
    fi
}

# Disable unnecessary services
disable_services() {
    echo_info "Disabling unnecessary services..."
    local services=("cups-browsed" "ModemManager")
    for service in "${services[@]}"; do
        if systemctl list-unit-files | grep -qw "$service.service"; then
            systemctl is-active --quiet "$service" && {
                systemctl disable "$service"
                systemctl stop "$service"
                echo_info "$service service disabled and stopped."
            } || echo_warn "$service service is already inactive."
        else
            echo_warn "$service service does not exist."
        fi
    done
}

# Optimize initramfs and GRUB configuration in parallel
optimize_initramfs_and_grub() {
    echo_info "Optimizing initramfs and GRUB in parallel..."
    local initramfs_conf="/etc/initramfs-tools/initramfs.conf"
    local grub_conf="/etc/default/grub"
    
    # Initramfs optimization
    if backup_file "$initramfs_conf"; then
        sed -i 's/^MODULES=most/MODULES=dep/' "$initramfs_conf" && {
            update-initramfs -u
            echo_info "initramfs optimized."
        } || echo_error "Failed to update initramfs."
    fi

    # GRUB optimization
    if backup_file "$grub_conf"; then
        sed -i 's/^GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=1/' "$grub_conf" && {
            update-grub
            echo_info "GRUB timeout reduced."
        } || echo_error "Failed to update GRUB."
    fi
}

# Execute parallel optimizations
execute_parallel_optimizations() {
    echo_info "Executing parallel optimizations..."
    local sysctl_conf="/etc/sysctl.conf"
    local systemd_conf="/etc/systemd/system.conf"
    local journal_conf="/etc/systemd/journald.conf"

    # Swappiness
    if backup_file "$sysctl_conf"; then
        echo 'vm.swappiness=10' >> "$sysctl_conf" && {
            sysctl -p
            echo_info "Swappiness set to 10."
        } || echo_error "Failed to set swappiness."
    fi

    # Systemd shutdown timeout
    if backup_file "$systemd_conf"; then
        sed -i 's/^#DefaultTimeoutStopSec=.*$/DefaultTimeoutStopSec=1s/' "$systemd_conf" && {
            systemctl daemon-reload
            echo_info "Systemd shutdown timeout set to 1 second."
        } || echo_error "Failed to set systemd shutdown timeout."
    fi

    # Systemd journal
    if backup_file "$journal_conf"; then
        sed -i 's/#Storage=auto/Storage=volatile/' "$journal_conf" && {
            systemctl restart systemd-journald
            echo_info "Systemd journal set to volatile."
        } || echo_error "Failed to configure systemd journal."
    fi
}

# Main function to run all optimizations
main() {
    check_root
    disable_services
    optimize_initramfs_and_grub
    execute_parallel_optimizations

    echo_info "Optimization complete. Please restart your system to see the changes."
}

main
