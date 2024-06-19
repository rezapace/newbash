Berikut adalah langkah-langkah lengkap untuk membuat, mengatur, dan mengonfigurasi swap file serta mengaktifkan hibernasi pada sistem Linux Mint:

### Membuat dan Mengatur Swap File

1. **Membuat Swap File**:
   Jika `fallocate` berhasil:
    ```bash
    sudo fallocate -l 16G /swapfile
    ```
   Jika `fallocate` tidak berhasil, gunakan:
    ```bash
    sudo dd if=/dev/zero of=/swapfile bs=1M count=16384
    ```

2. **Mengatur Izin Swap File**:
    ```bash
    sudo chmod 600 /swapfile
    ```

3. **Membuat Swap Area pada Swap File**:
    ```bash
    sudo mkswap /swapfile
    ```

4. **Mengaktifkan Swap File**:
    ```bash
    sudo swapon /swapfile
    ```

5. **Menambahkan Swap File ke /etc/fstab untuk Mengaktifkannya Secara Otomatis Saat Boot**:
    ```bash
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    ```

### Menyiapkan Hibernasi

1. **Menemukan UUID dari Swap File**:
    Jalankan perintah berikut untuk menemukan UUID dari partisi swap:
    ```bash
    sudo blkid
    ```
    Output akan menampilkan informasi seperti berikut:
    ```plaintext
    /dev/nvme0n1p1: UUID="BB87-35FE" BLOCK_SIZE="512" TYPE="vfat" PARTLABEL="EFI System Partition" PARTUUID="f2d9bdc5-d69a-417f-8f7a-6f51958b8afe"
    /dev/nvme0n1p2: UUID="dd1fe6bb-8476-4635-b233-1f8692284710" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="648ac220-c830-4ae4-b815-3ffb8af53c21"
    ```
    Temukan UUID yang terkait dengan `/swapfile`. Jika tidak ada entri untuk `/swapfile`, maka UUID-nya tidak diperlukan. Jika UUID diperlukan:
    ```bash
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo blkid | grep /swapfile
    ```

2. **Menemukan Offset dari Swap File**:
    Jalankan perintah berikut untuk menemukan offset dari swap file:
    ```bash
    sudo filefrag -v /swapfile | grep " 0:" | awk '{print $4}'
    ```
    Output akan menunjukkan offset seperti berikut:
    ```plaintext
    78610432..
    ```
    Catat nilai offset ini.

3. **Mengedit Konfigurasi GRUB untuk Menambahkan Parameter Hibernasi**:
    Edit file konfigurasi GRUB:
    ```bash
    sudo nano /etc/default/grub
    ```
    Temukan baris yang dimulai dengan `GRUB_CMDLINE_LINUX_DEFAULT` dan tambahkan parameter `resume` dan `resume_offset`:
    ```plaintext
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=d225649d-250a-42b0-b4b8-519ec3c2ee95 resume_offset=78610432"
    ```
    Gantilah `UUID=d225649d-250a-42b0-b4b8-519ec3c2ee95` dengan UUID yang didapatkan dari langkah sebelumnya (atau jika UUID tidak diperlukan, gunakan hanya path ke swapfile) dan `78610432` dengan nilai offset yang didapatkan dari langkah sebelumnya.

4. **Memperbarui Konfigurasi GRUB**:
    Jalankan perintah berikut untuk memperbarui konfigurasi GRUB:
    ```bash
    sudo update-grub
    ```

### Verifikasi dan Pengujian

1. **Verifikasi Swap File Aktif**:
    Jalankan perintah berikut untuk memverifikasi bahwa swap file aktif:
    ```bash
    sudo swapon --show
    ```
    Output seharusnya menunjukkan sesuatu seperti berikut:
    ```plaintext
    NAME      TYPE SIZE USED PRIO
    /swapfile file  16G   0B   -2
    ```

2. **Mengaktifkan Hibernasi**:
    Jalankan perintah berikut untuk menguji hibernasi:
    ```bash
    sudo systemctl hibernate
    ```

### Langkah-langkah Tambahan untuk Performa yang Lebih Cepat

- **Memastikan Swap File Terletak di SSD**: Jika memungkinkan, tempatkan swap file di SSD untuk akses yang lebih cepat.
- **Optimalkan Layanan Startup**: Nonaktifkan layanan yang tidak perlu yang berjalan saat startup.
- **Pastikan Kernel dan Driver Terbaru**: Selalu gunakan kernel dan driver terbaru untuk performa yang lebih baik.
- **Nonaktifkan Program Startup yang Tidak Penting**: Hapus atau nonaktifkan program yang tidak perlu berjalan otomatis saat boot.

Dengan mengikuti langkah-langkah ini, Anda seharusnya dapat mengkonfigurasi sistem Anda untuk mendukung hibernasi dengan swap file dan memastikan performa booting yang lebih cepat setelah hibernasi.


# hibernate di tambahkan di rofi
Jika Anda ingin menyimpan file `hibernate.desktop` di direktori `/home/r/.local/share/applications/app system/`, berikut adalah langkah-langkah yang lebih terperinci:

1. **Buat Direktori Tujuan (Jika Belum Ada):**

   Pastikan direktori `app system` ada di dalam `/home/r/.local/share/applications/`. Jika belum ada, buat direktori tersebut:

   ```bash
   mkdir -p /home/r/.local/share/applications/app\ system
   ```

2. **Buat dan Edit File `hibernate.desktop`:**

   Buat dan edit file `hibernate.desktop` di direktori tujuan:

   ```bash
   nano /home/r/.local/share/applications/app\ system/hibernate.desktop
   ```

   Tambahkan konten berikut ke dalam file:

   ```ini
   [Desktop Entry]
   Version=1.0
   Type=Application
   Name=Hibernate
   Exec=/home/r/Documents/Backups/hibernate.sh
   Icon=/path/to/restart-icon.png
   Terminal=false
   ```

   Simpan dan tutup editor (Ctrl+X, Y, Enter).

3. **Buat Skrip Shell `hibernate.sh`:**

   Buat dan edit skrip shell di direktori `/home/r/Documents/Backups`:

   ```bash
   nano /home/r/Documents/Backups/hibernate.sh
   ```

   Tambahkan konten berikut ke dalam skrip:

   ```bash
   #!/bin/bash

   # Skrip untuk menjalankan hibernate
   sudo pm-hibernate
   ```

   Simpan dan tutup editor (Ctrl+X, Y, Enter).

   Berikan izin eksekusi pada skrip:

   ```bash
   chmod +x /home/r/Documents/Backups/hibernate.sh
   ```

4. **Berikan Izin Eksekusi pada File `hibernate.desktop` (Opsional):**

   Berikan izin eksekusi pada file desktop (ini biasanya tidak diperlukan, tapi tidak ada salahnya untuk memastikan):

   ```bash
   chmod +x /home/r/.local/share/applications/app\ system/hibernate.desktop
   ```

5. **Tambahkan Aturan `sudoers` untuk `pm-hibernate`:**

   Agar skrip dapat berjalan tanpa meminta password, tambahkan aturan di `sudoers`:

   ```bash
   sudo visudo
   ```

   Tambahkan baris berikut di akhir file:

   ```ini
   r ALL=(ALL) NOPASSWD: /usr/sbin/pm-hibernate
   ```

   Simpan dan tutup editor (Ctrl+X, Y, Enter).

   Ganti `r` dengan username Anda.

6. **Uji Entri Desktop:**

   Sekarang, Anda dapat mencari aplikasi "Hibernate" di menu aplikasi Anda dan menjalankannya. Ini seharusnya menjalankan skrip `hibernate.sh`, yang kemudian mengeksekusi `pm-hibernate` dengan `sudo`.

Dengan langkah-langkah ini, Anda telah membuat entri desktop `hibernate.desktop` di lokasi yang benar dan memastikan skrip `hibernate.sh` dapat dijalankan dengan hak akses administrator tanpa meminta password setiap kali.