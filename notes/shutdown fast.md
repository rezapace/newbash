#!/bin/bash

# Skrip untuk mempercepat startup dan shutdown di Linux Mint Mate

# Fungsi untuk menampilkan pesan
echo_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

echo_warn() {
    echo -e "\e[33m[WARN]\e[0m $1"
}

echo_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# Fungsi untuk memeriksa status terakhir dan keluar jika ada kesalahan
check_status() {
    if [ $? -ne 0 ]; then
        echo_error "$1"
        exit 1
    fi
}

# Nonaktifkan layanan yang tidak diperlukan
disable_services() {
    echo_info "Menonaktifkan layanan yang tidak diperlukan..."
    services=(
        "bluetooth"
        "cups-browsed"
        "ModemManager"
    )
    for service in "${services[@]}"; do
        if sudo systemctl is-active --quiet "$service"; then
            sudo systemctl disable "$service" && sudo systemctl stop "$service"
            check_status "Gagal menonaktifkan layanan $service."
            echo_info "Layanan $service dinonaktifkan dan dihentikan."
        else
            echo_warn "Layanan $service sudah tidak aktif."
        fi
    done
}

# Optimalkan initramfs
optimize_initramfs() {
    echo_info "Mengoptimalkan initramfs..."
    if grep -q '^MODULES=most' /etc/initramfs-tools/initramfs.conf; then
        sudo sed -i 's/^MODULES=most/MODULES=dep/' /etc/initramfs-tools/initramfs.conf
        check_status "Gagal mengubah konfigurasi initramfs."
        sudo update-initramfs -u
        check_status "Gagal memperbarui initramfs."
        echo_info "initramfs dioptimalkan."
    else
        echo_warn "initramfs sudah diatur ke dep."
    fi
}

# Kurangi waktu tunggu grub
optimize_grub() {
    echo_info "Mengurangi waktu tunggu grub..."
    if grep -q '^GRUB_TIMEOUT=' /etc/default/grub; then
        sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
        check_status "Gagal mengubah waktu tunggu GRUB."
        sudo update-grub
        check_status "Gagal memperbarui grub."
        echo_info "Waktu tunggu grub dikurangi."
    else
        echo_error "Tidak dapat menemukan pengaturan GRUB_TIMEOUT."
    fi
}

# Tambahkan preload
add_preload() {
    echo_info "Menambahkan preload..."
    if ! dpkg -l | grep -q preload; then
        sudo apt-get install -y preload
        check_status "Gagal menginstal preload."
        sudo systemctl enable preload
        check_status "Gagal mengaktifkan preload."
        sudo systemctl start preload
        check_status "Gagal memulai preload."
        echo_info "Preload diinstal dan diaktifkan."
    else
        echo_warn "Preload sudah terpasang."
    fi
}

# Atur swappiness
optimize_swappiness() {
    echo_info "Mengatur swappiness..."
    if ! grep -q 'vm.swappiness=10' /etc/sysctl.conf; then
        echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
        check_status "Gagal mengatur swappiness."
        sudo sysctl -p
        check_status "Gagal memuat ulang sysctl."
        echo_info "Swappiness diatur ke 10."
    else
        echo_warn "Swappiness sudah diatur ke 10."
    fi
}

# Bersihkan file sementara
clean_temp_files() {
    echo_info "Membersihkan file sementara..."
    sudo rm -rf /tmp/* /var/tmp/*
    check_status "Gagal membersihkan file sementara."
    echo_info "File sementara dibersihkan."
}

# Kurangi waktu tunggu shutdown systemd
optimize_systemd_shutdown() {
    echo_info "Mengoptimalkan shutdown systemd..."
    if ! grep -q '^DefaultTimeoutStopSec=5s' /etc/systemd/system.conf; then
        sudo sed -i 's/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=5s/' /etc/systemd/system.conf
        check_status "Gagal mengatur waktu tunggu shutdown systemd."
        sudo systemctl daemon-reload
        check_status "Gagal memuat ulang systemd daemon."
        echo_info "Waktu tunggu shutdown systemd diatur ke 5 detik."
    else
        echo_warn "Waktu tunggu shutdown systemd sudah diatur ke 5 detik."
    fi
}

# Nonaktifkan hibernasi dan suspend
disable_hibernate_suspend() {
    echo_info "Menonaktifkan hibernasi dan suspend..."
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    check_status "Gagal menonaktifkan hibernasi dan suspend."
    echo_info "Hibernasi dan suspend dinonaktifkan."
}

# Optimalkan journal
optimize_journal() {
    echo_info "Mengoptimalkan journal systemd..."
    sudo sed -i 's/#Storage=auto/Storage=volatile/' /etc/systemd/journald.conf
    check_status "Gagal mengatur konfigurasi journald."
    sudo systemctl restart systemd-journald
    check_status "Gagal memulai ulang systemd-journald."
    echo_info "Journal systemd diatur ke volatile."
}

# Jalankan semua fungsi
main() {
    disable_services
    optimize_initramfs
    optimize_grub
    add_preload
    optimize_swappiness
    clean_temp_files
    optimize_systemd_shutdown
    disable_hibernate_suspend
    optimize_journal

    echo_info "Optimasi selesai. Silakan restart sistem Anda untuk melihat perubahan."
}

main



# v2

#!/bin/bash

# Skrip untuk mempercepat startup dan shutdown di Linux Mint Mate

# Fungsi untuk menampilkan pesan
echo_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

echo_warn() {
    echo -e "\e[33m[WARN]\e[0m $1"
}

echo_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# Fungsi untuk memeriksa status terakhir dan keluar jika ada kesalahan
check_status() {
    if [ $? -ne 0 ]; then
        echo_error "$1"
        exit 1
    fi
}

# Memeriksa apakah skrip dijalankan dengan hak akses root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo_error "Skrip ini harus dijalankan sebagai root."
        exit 1
    fi
}

# Nonaktifkan layanan yang tidak diperlukan
disable_services() {
    echo_info "Menonaktifkan layanan yang tidak diperlukan..."
    local services=(
        "bluetooth"
        "cups-browsed"
        "ModemManager"
    )
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            systemctl disable "$service" && systemctl stop "$service"
            check_status "Gagal menonaktifkan layanan $service."
            echo_info "Layanan $service dinonaktifkan dan dihentikan."
        else
            echo_warn "Layanan $service sudah tidak aktif."
        fi
    done
}

# Optimalkan initramfs
optimize_initramfs() {
    echo_info "Mengoptimalkan initramfs..."
    if grep -q '^MODULES=most' /etc/initramfs-tools/initramfs.conf; then
        sed -i 's/^MODULES=most/MODULES=dep/' /etc/initramfs-tools/initramfs.conf
        check_status "Gagal mengubah konfigurasi initramfs."
        update-initramfs -u
        check_status "Gagal memperbarui initramfs."
        echo_info "initramfs dioptimalkan."
    else
        echo_warn "initramfs sudah diatur ke dep."
    fi
}

# Kurangi waktu tunggu grub
optimize_grub() {
    echo_info "Mengurangi waktu tunggu grub..."
    if grep -q '^GRUB_TIMEOUT=' /etc/default/grub; then
        sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
        check_status "Gagal mengubah waktu tunggu GRUB."
        update-grub
        check_status "Gagal memperbarui grub."
        echo_info "Waktu tunggu grub dikurangi."
    else
        echo_error "Tidak dapat menemukan pengaturan GRUB_TIMEOUT."
    fi
}

# Tambahkan preload
add_preload() {
    echo_info "Menambahkan preload..."
    if ! dpkg -l | grep -q preload; then
        apt-get install -y preload
        check_status "Gagal menginstal preload."
        systemctl enable preload
        check_status "Gagal mengaktifkan preload."
        systemctl start preload
        check_status "Gagal memulai preload."
        echo_info "Preload diinstal dan diaktifkan."
    else
        echo_warn "Preload sudah terpasang."
    fi
}

# Atur swappiness
optimize_swappiness() {
    echo_info "Mengatur swappiness..."
    if ! grep -q 'vm.swappiness=10' /etc/sysctl.conf; then
        echo 'vm.swappiness=10' >> /etc/sysctl.conf
        check_status "Gagal mengatur swappiness."
        sysctl -p
        check_status "Gagal memuat ulang sysctl."
        echo_info "Swappiness diatur ke 10."
    else
        echo_warn "Swappiness sudah diatur ke 10."
    fi
}

# Bersihkan file sementara
clean_temp_files() {
    echo_info "Membersihkan file sementara..."
    rm -rf /tmp/* /var/tmp/*
    check_status "Gagal membersihkan file sementara."
    echo_info "File sementara dibersihkan."
}

# Kurangi waktu tunggu shutdown systemd
optimize_systemd_shutdown() {
    echo_info "Mengoptimalkan shutdown systemd..."
    if ! grep -q '^DefaultTimeoutStopSec=5s' /etc/systemd/system.conf; then
        sed -i 's/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=5s/' /etc/systemd/system.conf
        check_status "Gagal mengatur waktu tunggu shutdown systemd."
        systemctl daemon-reload
        check_status "Gagal memuat ulang systemd daemon."
        echo_info "Waktu tunggu shutdown systemd diatur ke 5 detik."
    else
        echo_warn "Waktu tunggu shutdown systemd sudah diatur ke 5 detik."
    fi
}

# Nonaktifkan hibernasi dan suspend
disable_hibernate_suspend() {
    echo_info "Menonaktifkan hibernasi dan suspend..."
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    check_status "Gagal menonaktifkan hibernasi dan suspend."
    echo_info "Hibernasi dan suspend dinonaktifkan."
}

# Optimalkan journal
optimize_journal() {
    echo_info "Mengoptimalkan journal systemd..."
    sed -i 's/#Storage=auto/Storage=volatile/' /etc/systemd/journald.conf
    check_status "Gagal mengatur konfigurasi journald."
    systemctl restart systemd-journald
    check_status "Gagal memulai ulang systemd-journald."
    echo_info "Journal systemd diatur ke volatile."
}

# Jalankan semua fungsi
main() {
    check_root
    disable_services
    optimize_initramfs
    optimize_grub
    add_preload
    optimize_swappiness
    clean_temp_files
    optimize_systemd_shutdown
    disable_hibernate_suspend
    optimize_journal

    echo_info "Optimasi selesai. Silakan restart sistem Anda untuk melihat perubahan."
}

main


# v3
#!/bin/bash

# Skrip untuk mempercepat startup dan shutdown di Linux Mint Mate

# Fungsi untuk menampilkan pesan
echo_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

echo_warn() {
    echo -e "\e[33m[WARN]\e[0m $1"
}

echo_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# Fungsi untuk memeriksa status terakhir dan keluar jika ada kesalahan
check_status() {
    if [ $1 -ne 0 ]; then
        echo_error "$2"
        exit 1
    fi
}

# Memeriksa apakah skrip dijalankan dengan hak akses root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo_error "Skrip ini harus dijalankan sebagai root."
        exit 1
    fi
}

# Nonaktifkan layanan yang tidak diperlukan
disable_services() {
    echo_info "Menonaktifkan layanan yang tidak diperlukan..."
    local services=(
        "bluetooth"
        "cups-browsed"
        "ModemManager"
    )
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            systemctl disable "$service" && systemctl stop "$service"
            check_status $? "Gagal menonaktifkan layanan $service."
            echo_info "Layanan $service dinonaktifkan dan dihentikan."
        else
            echo_warn "Layanan $service sudah tidak aktif."
        fi
    done
}

# Optimalkan initramfs
optimize_initramfs() {
    echo_info "Mengoptimalkan initramfs..."
    if grep -q '^MODULES=most' /etc/initramfs-tools/initramfs.conf; then
        sed -i 's/^MODULES=most/MODULES=dep/' /etc/initramfs-tools/initramfs.conf
        check_status $? "Gagal mengubah konfigurasi initramfs."
        update-initramfs -u
        check_status $? "Gagal memperbarui initramfs."
        echo_info "initramfs dioptimalkan."
    else
        echo_warn "initramfs sudah diatur ke dep."
    fi
}

# Kurangi waktu tunggu grub
optimize_grub() {
    echo_info "Mengurangi waktu tunggu grub..."
    if grep -q '^GRUB_TIMEOUT=' /etc/default/grub; then
        sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
        check_status $? "Gagal mengubah waktu tunggu GRUB."
        update-grub
        check_status $? "Gagal memperbarui grub."
        echo_info "Waktu tunggu grub dikurangi."
    else
        echo_error "Tidak dapat menemukan pengaturan GRUB_TIMEOUT."
    fi
}

# Tambahkan preload
add_preload() {
    echo_info "Menambahkan preload..."
    if ! dpkg-query -W -f='${Status}' preload 2>/dev/null | grep -q "install ok installed"; then
        apt-get install -y preload
        check_status $? "Gagal menginstal preload."
        systemctl enable preload && systemctl start preload
        check_status $? "Gagal mengaktifkan atau memulai preload."
        echo_info "Preload diinstal dan diaktifkan."
    else
        echo_warn "Preload sudah terpasang."
    fi
}

# Atur swappiness
optimize_swappiness() {
    echo_info "Mengatur swappiness..."
    if ! grep -q 'vm.swappiness=10' /etc/sysctl.conf; then
        echo 'vm.swappiness=10' >> /etc/sysctl.conf
        check_status $? "Gagal mengatur swappiness."
        sysctl -p
        check_status $? "Gagal memuat ulang sysctl."
        echo_info "Swappiness diatur ke 10."
    else
        echo_warn "Swappiness sudah diatur ke 10."
    fi
}

# Bersihkan file sementara
clean_temp_files() {
    echo_info "Membersihkan file sementara..."
    rm -rf /tmp/* /var/tmp/*
    check_status $? "Gagal membersihkan file sementara."
    echo_info "File sementara dibersihkan."
}

# Kurangi waktu tunggu shutdown systemd
optimize_systemd_shutdown() {
    echo_info "Mengoptimalkan shutdown systemd..."
    if ! grep -q '^DefaultTimeoutStopSec=5s' /etc/systemd/system.conf; then
        sed -i 's/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=5s/' /etc/systemd/system.conf
        check_status $? "Gagal mengatur waktu tunggu shutdown systemd."
        systemctl daemon-reload
        check_status $? "Gagal memuat ulang systemd daemon."
        echo_info "Waktu tunggu shutdown systemd diatur ke 5 detik."
    else
        echo_warn "Waktu tunggu shutdown systemd sudah diatur ke 5 detik."
    fi
}

# Nonaktifkan hibernasi dan suspend
disable_hibernate_suspend() {
    echo_info "Menonaktifkan hibernasi dan suspend..."
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    check_status $? "Gagal menonaktifkan hibernasi dan suspend."
    echo_info "Hibernasi dan suspend dinonaktifkan."
}

# Optimalkan journal
optimize_journal() {
    echo_info "Mengoptimalkan journal systemd..."
    sed -i 's/#Storage=auto/Storage=volatile/' /etc/systemd/journald.conf
    check_status $? "Gagal mengatur konfigurasi journald."
    systemctl restart systemd-journald
    check_status $? "Gagal memulai ulang systemd-journald."
    echo_info "Journal systemd diatur ke volatile."
}

# Jalankan semua fungsi
main() {
    check_root
    disable_services
    optimize_initramfs
    optimize_grub
    add_preload
    optimize_swappiness
    clean_temp_files
    optimize_systemd_shutdown
    disable_hibernate_suspend
    optimize_journal

    echo_info "Optimasi selesai. Silakan restart sistem Anda untuk melihat perubahan."
}

main


# final
#!/bin/bash

# Script to speed up startup and shutdown on Linux Mint Mate

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
    local services=(
        "bluetooth"
        "cups-browsed"
        "ModemManager"
    )
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            systemctl disable "$service" && systemctl stop "$service"
            check_status $? "Failed to disable $service service."
            echo_info "$service service disabled and stopped."
        else
            echo_warn "$service service is already inactive."
        fi
    done
}

# Optimize initramfs
optimize_initramfs() {
    echo_info "Optimizing initramfs..."
    if grep -q '^MODULES=most' /etc/initramfs-tools/initramfs.conf; then
        sed -i 's/^MODULES=most/MODULES=dep/' /etc/initramfs-tools/initramfs.conf
        check_status $? "Failed to modify initramfs configuration."
        update-initramfs -u
        check_status $? "Failed to update initramfs."
        echo_info "initramfs optimized."
    else
        echo_warn "initramfs is already set to 'dep'."
    fi
}

# Reduce grub timeout
optimize_grub() {
    echo_info "Reducing grub timeout..."
    if grep -q '^GRUB_TIMEOUT=' /etc/default/grub; then
        sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
        check_status $? "Failed to modify GRUB timeout."
        update-grub
        check_status $? "Failed to update grub."
        echo_info "GRUB timeout reduced."
    else
        echo_error "Could not find GRUB_TIMEOUT setting."
    fi
}

# Add preload
add_preload() {
    echo_info "Adding preload..."
    if ! dpkg-query -W -f='${Status}' preload 2>/dev/null | grep -q "install ok installed"; then
        apt-get install -y preload
        check_status $? "Failed to install preload."
        systemctl enable preload && systemctl start preload
        check_status $? "Failed to enable or start preload."
        echo_info "Preload installed and enabled."
    else
        echo_warn "Preload is already installed."
    fi
}

# Set swappiness
optimize_swappiness() {
    echo_info "Setting swappiness..."
    if ! grep -q 'vm.swappiness=10' /etc/sysctl.conf; then
        echo 'vm.swappiness=10' >> /etc/sysctl.conf
        check_status $? "Failed to set swappiness."
        sysctl -p
        check_status $? "Failed to reload sysctl."
        echo_info "Swappiness set to 10."
    else
        echo_warn "Swappiness is already set to 10."
    fi
}

# Clean temporary files
clean_temp_files() {
    echo_info "Cleaning temporary files..."
    rm -rf /tmp/* /var/tmp/*
    check_status $? "Failed to clean temporary files."
    echo_info "Temporary files cleaned."
}

# Reduce systemd shutdown timeout
optimize_systemd_shutdown() {
    echo_info "Optimizing systemd shutdown..."
    if ! grep -q '^DefaultTimeoutStopSec=5s' /etc/systemd/system.conf; then
        sed -i 's/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=5s/' /etc/systemd/system.conf
        check_status $? "Failed to set systemd shutdown timeout."
        systemctl daemon-reload
        check_status $? "Failed to reload systemd daemon."
        echo_info "Systemd shutdown timeout set to 5 seconds."
    else
        echo_warn "Systemd shutdown timeout is already set to 5 seconds."
    fi
}

# Disable hibernate and suspend
disable_hibernate_suspend() {
    echo_info "Disabling hibernate and suspend..."
    systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    check_status $? "Failed to disable hibernate and suspend."
    echo_info "Hibernate and suspend disabled."
}

# Optimize systemd journal
optimize_journal() {
    echo_info "Optimizing systemd journal..."
    sed -i 's/#Storage=auto/Storage=volatile/' /etc/systemd/journald.conf
    check_status $? "Failed to configure journald."
    systemctl restart systemd-journald
    check_status $? "Failed to restart systemd-journald."
    echo_info "Systemd journal set to volatile."
}

# Run all functions
main() {
    check_root
    disable_services
    optimize_initramfs
    optimize_grub
    add_preload
    optimize_swappiness
    clean_temp_files
    optimize_systemd_shutdown
    disable_hibernate_suspend
    optimize_journal

    echo_info "Optimization complete. Please restart your system to see the changes."
}

main
