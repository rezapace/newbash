Mempercepat proses shutdown dan startup pada Linux Mint Mate dapat dilakukan dengan beberapa cara. Di bawah ini adalah beberapa langkah yang dapat Anda coba untuk mempercepat kedua proses tersebut.

### Mempercepat Startup

1. **Nonaktifkan Layanan yang Tidak Diperlukan:**
   Beberapa layanan mungkin tidak diperlukan saat startup. Anda bisa menonaktifkannya dengan `systemctl` atau menggunakan `rcconf` atau `bum` untuk manajemen layanan.

   ```bash
   sudo systemctl disable nama_layanan
   ```

2. **Kurangi Aplikasi yang Dimulai saat Startup:**
   Nonaktifkan aplikasi yang tidak perlu dimulai saat startup. Anda bisa mengelola aplikasi startup melalui "Startup Applications" di menu Mate.

3. **Optimalkan Initramfs:**
   Mengurangi modul yang tidak perlu dalam initramfs dapat mempercepat proses booting.

   ```bash
   sudo nano /etc/initramfs-tools/initramfs.conf
   ```

   Cari `MODULES=most` dan ubah menjadi `MODULES=dep`, kemudian update initramfs:

   ```bash
   sudo update-initramfs -u
   ```

4. **Update Grub Configuration:**
   Mengurangi waktu tunggu grub dapat mempercepat startup.

   ```bash
   sudo nano /etc/default/grub
   ```

   Ubah nilai `GRUB_TIMEOUT` menjadi 1 atau 0, kemudian update grub:

   ```bash
   sudo update-grub
   ```

5. **Gunakan Profile Boot Optimization:**
   Gunakan profil boot untuk mengoptimalkan proses booting dengan systemd.

   ```bash
   sudo systemd-analyze profile
   ```

### Mempercepat Shutdown

1. **Nonaktifkan Layanan yang Tidak Diperlukan saat Shutdown:**
   Beberapa layanan mungkin tidak perlu dimatikan secara bersamaan. Anda bisa menonaktifkannya atau mengatur prioritas shutdown.

   ```bash
   sudo systemctl disable nama_layanan
   ```

2. **Kurangi Waktu Tunggu Layanan:**
   Kurangi waktu tunggu untuk layanan yang berhenti.

   ```bash
   sudo nano /etc/systemd/system.conf
   ```

   Ubah `DefaultTimeoutStopSec` menjadi nilai yang lebih kecil, misalnya `10s`.

3. **Memaksa Layanan untuk Segera Berhenti:**
   Anda dapat mengubah konfigurasi systemd untuk memaksa layanan berhenti lebih cepat.

   ```bash
   sudo nano /etc/systemd/system.conf
   ```

   Tambahkan atau ubah nilai `DefaultTimeoutStopSec=10s`.

4. **Gunakan Systemd untuk Analisis dan Optimasi:**
   Gunakan perintah systemd-analyze untuk menganalisis waktu shutdown dan mengoptimalkannya.

   ```bash
   sudo systemd-analyze blame
   sudo systemd-analyze critical-chain
   ```

Dengan langkah-langkah di atas, Anda bisa mempercepat proses startup dan shutdown pada Linux Mint Mate. Jika Anda mengalami masalah atau butuh penjelasan lebih lanjut, jangan ragu untuk bertanya.

Ya, ada beberapa langkah tambahan dan metode yang lebih maju untuk mempercepat proses startup dan shutdown di Linux Mint Mate. Berikut beberapa langkah tambahan yang bisa Anda coba:

### Mempercepat Startup

1. **Parallelize Boot Process:**
   Pastikan booting dilakukan secara paralel untuk mempercepat proses.

   ```bash
   sudo nano /etc/systemd/system.conf
   ```

   Cari dan setel `DefaultDependencies=no`.

2. **Use Preload:**
   Preload adalah daemon yang memantau aplikasi yang sering Anda gunakan dan memuatnya ke memori sebelumnya.

   ```bash
   sudo apt-get install preload
   sudo systemctl enable preload
   sudo systemctl start preload
   ```

3. **Reduce Kernel Load Time:**
   Anda bisa menghapus modul kernel yang tidak diperlukan. Pastikan Anda tahu apa yang Anda lakukan saat menghapus modul kernel.

   ```bash
   sudo nano /etc/modules
   ```

   Hapus modul yang tidak diperlukan dan update initramfs.

   ```bash
   sudo update-initramfs -u
   ```

4. **Optimize Swappiness:**
   Mengurangi nilai swappiness dapat mempercepat proses booting.

   ```bash
   sudo sysctl vm.swappiness=10
   ```

   Untuk membuatnya permanen:

   ```bash
   sudo nano /etc/sysctl.conf
   ```

   Tambahkan `vm.swappiness=10`.

### Mempercepat Shutdown

1. **Use `systemd-analyze` for Troubleshooting:**
   Analisis layanan yang lambat berhenti dengan `systemd-analyze` dan optimalkan.

   ```bash
   sudo systemd-analyze blame
   ```

2. **Shutdown Quickly by Adjusting Systemd Settings:**
   Edit file systemd untuk mengurangi waktu tunggu layanan saat shutdown.

   ```bash
   sudo nano /etc/systemd/system.conf
   ```

   Tambahkan atau ubah:

   ```ini
   DefaultTimeoutStopSec=5s
   ```
   
3. **Disable Hibernate and Suspend:**
   Jika Anda tidak menggunakan fitur hibernate atau suspend, menonaktifkannya dapat mengurangi waktu shutdown.

   ```bash
   sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
   ```

4. **Clean Temporary Files:**
   Membersihkan file sementara yang tidak diperlukan secara teratur dapat mempercepat proses shutdown.

   Buat script untuk membersihkan file sementara dan tambahkan ke crontab.

   ```bash
   #!/bin/bash
   sudo rm -rf /tmp/*
   sudo rm -rf /var/tmp/*
   ```

   Buat crontab:

   ```bash
   sudo crontab -e
   ```

   Tambahkan baris berikut:

   ```cron
   0 2 * * * /path/to/clean_temp.sh
   ```

### Advanced: SystemD-Boot Optimization

1. **Optimize SystemD Services:**
   Analisis dan optimalkan layanan systemd yang memakan waktu lama.

   ```bash
   systemd-analyze blame
   ```

   Nonaktifkan layanan yang tidak diperlukan:

   ```bash
   sudo systemctl disable nama_layanan
   ```

2. **Profile Boot with SystemD:**
   Gunakan profil systemd untuk mengoptimalkan boot.

   ```bash
   sudo systemd-analyze plot > boot.svg
   ```

   Buka `boot.svg` di browser untuk melihat detail waktu boot dan identifikasi layanan yang lambat.

Dengan langkah-langkah tambahan ini, Anda seharusnya dapat lebih mempercepat proses startup dan shutdown di Linux Mint Mate. Pastikan untuk melakukan backup sebelum melakukan perubahan signifikan pada sistem Anda.


# 1 script
#!/bin/bash

# Skrip untuk mempercepat startup dan shutdown di Linux Mint Mate

# Fungsi untuk menampilkan pesan
echo_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
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
        sudo systemctl disable "$service"
        sudo systemctl stop "$service"
    done
}

# Optimalkan initramfs
optimize_initramfs() {
    echo_info "Mengoptimalkan initramfs..."
    sudo sed -i 's/^MODULES=most/MODULES=dep/' /etc/initramfs-tools/initramfs.conf
    sudo update-initramfs -u
}

# Kurangi waktu tunggu grub
optimize_grub() {
    echo_info "Mengurangi waktu tunggu grub..."
    sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
    sudo update-grub
}

# Tambahkan preload
add_preload() {
    echo_info "Menambahkan preload..."
    sudo apt-get install -y preload
    sudo systemctl enable preload
    sudo systemctl start preload
}

# Atur swappiness
optimize_swappiness() {
    echo_info "Mengatur swappiness..."
    echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
}

# Bersihkan file sementara
clean_temp_files() {
    echo_info "Membersihkan file sementara..."
    sudo rm -rf /tmp/*
    sudo rm -rf /var/tmp/*
}

# Kurangi waktu tunggu shutdown systemd
optimize_systemd_shutdown() {
    echo_info "Mengoptimalkan shutdown systemd..."
    sudo sed -i 's/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=5s/' /etc/systemd/system.conf
    sudo systemctl daemon-reload
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

    echo_info "Optimasi selesai. Silakan restart sistem Anda untuk melihat perubahan."
}

main


# modif script
Berikut adalah skrip Bash yang telah dimodifikasi dan ditingkatkan untuk mempercepat startup dan shutdown di Linux Mint Mate. Skrip ini mencakup lebih banyak optimasi, penanganan kesalahan, dan output berwarna untuk kemudahan dalam membaca pesan.

### Skrip Bash: `optimize_linux_mint.sh`

```bash
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
        sudo update-initramfs -u
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
        sudo update-grub
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
        sudo systemctl enable preload
        sudo systemctl start preload
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
        sudo sysctl -p
        echo_info "Swappiness diatur ke 10."
    else
        echo_warn "Swappiness sudah diatur ke 10."
    fi
}

# Bersihkan file sementara
clean_temp_files() {
    echo_info "Membersihkan file sementara..."
    sudo rm -rf /tmp/*
    sudo rm -rf /var/tmp/*
    echo_info "File sementara dibersihkan."
}

# Kurangi waktu tunggu shutdown systemd
optimize_systemd_shutdown() {
    echo_info "Mengoptimalkan shutdown systemd..."
    if ! grep -q '^DefaultTimeoutStopSec=5s' /etc/systemd/system.conf; then
        sudo sed -i 's/^#DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=5s/' /etc/systemd/system.conf
        sudo systemctl daemon-reload
        echo_info "Waktu tunggu shutdown systemd diatur ke 5 detik."
    else
        echo_warn "Waktu tunggu shutdown systemd sudah diatur ke 5 detik."
    fi
}

# Nonaktifkan hibernasi dan suspend
disable_hibernate_suspend() {
    echo_info "Menonaktifkan hibernasi dan suspend..."
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    echo_info "Hibernasi dan suspend dinonaktifkan."
}

# Optimalkan journal
optimize_journal() {
    echo_info "Mengoptimalkan journal systemd..."
    sudo sed -i 's/#Storage=auto/Storage=volatile/' /etc/systemd/journald.conf
    sudo systemctl restart systemd-journald
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
```

### Cara Menggunakan Skrip

1. **Simpan skrip di file:**
   Simpan skrip di file bernama `optimize_linux_mint.sh`.

   ```bash
   nano optimize_linux_mint.sh
   ```

   Tempelkan skrip di atas ke editor dan simpan.

2. **Buat skrip dapat dieksekusi:**
   Ubah izin skrip agar dapat dieksekusi.

   ```bash
   chmod +x optimize_linux_mint.sh
   ```

3. **Jalankan skrip:**
   Jalankan skrip sebagai root atau dengan sudo.

   ```bash
   sudo ./optimize_linux_mint.sh
   ```

Skrip ini akan menonaktifkan layanan yang tidak diperlukan, mengoptimalkan initramfs, mengurangi waktu tunggu grub, menambahkan preload, mengatur swappiness, membersihkan file sementara, mengatur timeout shutdown systemd, menonaktifkan hibernasi dan suspend, serta mengoptimalkan journal systemd. Setelah menjalankan skrip, silakan restart sistem Anda untuk melihat perubahan.


# penjelasan 
Skrip Bash yang diberikan bertujuan untuk mempercepat proses startup dan shutdown pada Linux Mint Mate. Berikut adalah penjelasan terperinci tentang apa yang dilakukan oleh setiap bagian skrip:

### Fungsi-fungsi Bantuan

1. **echo_info()**
   - Menampilkan pesan informasi berwarna hijau.
   - Parameter: Pesan yang ingin ditampilkan.

2. **echo_warn()**
   - Menampilkan pesan peringatan berwarna kuning.
   - Parameter: Pesan yang ingin ditampilkan.

3. **echo_error()**
   - Menampilkan pesan kesalahan berwarna merah.
   - Parameter: Pesan yang ingin ditampilkan.

### Fungsi Utama

1. **disable_services()**
   - Menonaktifkan layanan yang tidak diperlukan untuk mempercepat startup.
   - Layanan yang dinonaktifkan: `bluetooth`, `cups-browsed`, `ModemManager`.
   - Mengecek apakah layanan aktif sebelum menonaktifkannya untuk menghindari kesalahan.
   - Menggunakan `systemctl disable` untuk menonaktifkan layanan dan `systemctl stop` untuk menghentikannya.

2. **optimize_initramfs()**
   - Mengoptimalkan `initramfs` dengan mengubah konfigurasi modul dari `most` ke `dep`, yang mengurangi jumlah modul yang dimuat saat booting.
   - Memperbarui `initramfs` dengan perintah `update-initramfs -u`.

3. **optimize_grub()**
   - Mengurangi waktu tunggu grub dengan mengubah nilai `GRUB_TIMEOUT` menjadi `1`.
   - Memperbarui konfigurasi grub dengan perintah `update-grub`.

4. **add_preload()**
   - Memasang dan mengaktifkan `preload`, sebuah daemon yang memuat aplikasi yang sering digunakan ke dalam memori sebelumnya untuk mempercepat akses.
   - Mengecek apakah `preload` sudah terpasang sebelum mencoba memasangnya.

5. **optimize_swappiness()**
   - Mengatur nilai `swappiness` ke `10` untuk mengurangi penggunaan swap dan meningkatkan kinerja sistem.
   - Memuat pengaturan baru dengan perintah `sysctl -p`.

6. **clean_temp_files()**
   - Membersihkan file sementara di direktori `/tmp` dan `/var/tmp` untuk mengosongkan ruang dan mengurangi beban sistem.

7. **optimize_systemd_shutdown()**
   - Mengurangi waktu tunggu shutdown untuk layanan systemd dengan mengubah nilai `DefaultTimeoutStopSec` menjadi `5s` di konfigurasi systemd.
   - Memuat ulang konfigurasi systemd dengan perintah `systemctl daemon-reload`.

8. **disable_hibernate_suspend()**
   - Menonaktifkan fitur hibernasi dan suspend untuk mempercepat shutdown dan mencegah masalah terkait daya.
   - Menggunakan perintah `systemctl mask` untuk menonaktifkan target sleep, suspend, hibernate, dan hybrid-sleep.

9. **optimize_journal()**
   - Mengatur journal systemd agar menggunakan penyimpanan volatile (RAM) untuk mengurangi beban I/O pada disk.
   - Mengubah konfigurasi `journald.conf` dan memulai ulang layanan journal dengan perintah `systemctl restart systemd-journald`.

### Fungsi Utama Skrip

10. **main()**
    - Memanggil semua fungsi utama dalam urutan yang telah ditentukan.
    - Menampilkan pesan bahwa optimasi selesai dan meminta pengguna untuk me-restart sistem untuk melihat perubahan.

### Cara Penggunaan Skrip

1. **Simpan skrip di file:**
   - Simpan skrip ke dalam file bernama `optimize_linux_mint.sh`.

   ```bash
   nano optimize_linux_mint.sh
   ```

   Tempelkan isi skrip ke dalam editor dan simpan.

2. **Buat skrip dapat dieksekusi:**
   - Ubah izin file agar skrip dapat dieksekusi.

   ```bash
   chmod +x optimize_linux_mint.sh
   ```

3. **Jalankan skrip:**
   - Jalankan skrip sebagai root atau dengan sudo.

   ```bash
   sudo ./optimize_linux_mint.sh
   ```

### Kesimpulan

Skrip ini melakukan berbagai optimasi untuk mempercepat proses startup dan shutdown di Linux Mint Mate dengan menonaktifkan layanan yang tidak diperlukan, mengoptimalkan initramfs dan grub, menambahkan preload, mengatur swappiness, membersihkan file sementara, mengurangi waktu tunggu shutdown systemd, menonaktifkan hibernasi dan suspend, serta mengoptimalkan journal systemd. Setelah menjalankan skrip, Anda perlu me-restart sistem Anda untuk melihat perubahan.


# final script

Berikut adalah versi yang lebih terstruktur, dengan tambahan pengecekan kesalahan dan sedikit peningkatan pada beberapa bagian untuk memastikan kompatibilitas dan keandalan yang lebih baik:

```bash
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
```

### Perubahan Utama:
1. **Penambahan `check_status`**: Fungsi ini digunakan untuk memeriksa status terakhir dari setiap perintah yang dijalankan dan keluar jika terjadi kesalahan, memastikan bahwa pengguna segera tahu jika ada sesuatu yang salah.
2. **Peningkatan Pengecekan Kesalahan**: Pada setiap langkah di mana ada modifikasi sistem yang dilakukan, ditambahkan pengecekan kesalahan menggunakan `check_status`.
3. **Struktur Lebih Teratur**: Skrip diatur agar lebih mudah dibaca dan dipelihara.
4. **Pembersihan Temp File Sekaligus**: Menggabungkan perintah `rm -rf /tmp/*` dan `rm -rf /var/tmp/*` menjadi satu perintah.