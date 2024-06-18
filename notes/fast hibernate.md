Berikut adalah panduan lengkap dan koreksi untuk konfigurasi GRUB dan Zswap:

### Menggunakan `pm-utils` untuk Hibernasi

1. **Instal `pm-utils`:**
   ```bash
   sudo apt-get install pm-utils
   ```

2. **Hibernasi Menggunakan `pm-utils`:**
   ```bash
   sudo pm-hibernate
   ```

### Memastikan Swap dan UUID

1. **Periksa Swap Aktif:**
   ```bash
   sudo swapon --show
   ```

2. **Periksa UUID Swap:**
   ```bash
   sudo findmnt -no SOURCE,UUID -T /swapfile
   ```

3. **Periksa Offset Swap:**
   ```bash
   sudo filefrag -v /swapfile | grep " 0:" | awk '{print $4}'
   ```

### Tambahkan Konfigurasi ke GRUB

1. **Edit `/etc/default/grub`:**
   ```bash
   sudo nano /etc/default/grub
   ```

2. **Tambahkan Parameter:**
   Tambahkan parameter berikut ke baris `GRUB_CMDLINE_LINUX_DEFAULT`:
   ```bash
   GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=dd1fe6bb-8476-4635-b233-1f8692284710 resume_offset=78254080 zswap.enabled=1 zswap.compressor=lz4 zswap.max_pool_percent=20"
   ```

3. **Perbarui GRUB:**
   ```bash
   sudo update-grub
   ```

### Optimalisasi Tambahan

1. **Nonaktifkan Layanan Tidak Perlu:**
   ```bash
   sudo systemctl disable <service_name>
   ```

2. **Kurangi Swappiness:**
   ```bash
   sudo sysctl vm.swappiness=10
   ```
   Tambahkan ke `/etc/sysctl.conf` agar permanen:
   ```bash
   vm.swappiness=10
   ```

### Rekomendasi:

- Nonaktifkan `keyboard_backlight_resume.service` jika tidak diperlukan:
  ```bash
  sudo systemctl disable keyboard_backlight_resume.service
  ```

- Jika diperlukan, periksa log lebih lanjut untuk layanan tersebut untuk mengetahui penyebab kegagalannya:
  ```bash
  journalctl -u keyboard_backlight_resume.service
  ```

Secara keseluruhan, tidak ada kesalahan kritis yang mempengaruhi hibernasi dan resume sistem Anda.

`Tweak Kernel Parameters` berarti menyesuaikan parameter kernel untuk mengoptimalkan kinerja sistem, termasuk saat hibernasi. Berikut penjelasan untuk parameter `vm.dirty_background_ratio` dan `vm.dirty_ratio`:

1. **`vm.dirty_background_ratio`**:
   - Menentukan persentase memori sistem yang bisa terisi oleh data yang belum ditulis ke disk (dirty data) sebelum proses background menulis data tersebut ke disk.
   - Nilai 5 berarti ketika 5% dari total RAM terisi oleh dirty data, proses background akan mulai menulis data ke disk.

2. **`vm.dirty_ratio`**:
   - Menentukan persentase memori sistem yang bisa terisi oleh dirty data sebelum proses foreground (seperti aplikasi) harus menunggu data tersebut ditulis ke disk.
   - Nilai 10 berarti ketika 10% dari total RAM terisi oleh dirty data, semua proses penulisan akan berhenti sampai data tersebut ditulis ke disk.

### Mengapa Ini Membantu?
- **Mengurangi Latensi**: Dengan menetapkan nilai rendah untuk parameter ini, data lebih sering ditulis ke disk dalam jumlah kecil, mengurangi waktu yang diperlukan untuk menulis semua data saat hibernasi.
- **Kinerja Lebih Stabil**: Mencegah penumpukan data yang besar di RAM yang harus ditulis sekaligus saat hibernasi, yang dapat menyebabkan jeda waktu yang lama.

### Cara Menyetelnya:
1. Buka file konfigurasi sysctl:
   ```bash
   sudo nano /etc/sysctl.conf
   ```

2. Tambahkan baris berikut ke file:
   ```bash
   vm.dirty_background_ratio = 5
   vm.dirty_ratio = 10
   ```

3. Simpan file dan keluar dari editor (Ctrl+X, lalu Y, dan Enter).

4. Terapkan perubahan:
   ```bash
   sudo sysctl -p
   ```

Dengan melakukan penyesuaian ini, Anda dapat mempercepat proses hibernasi dengan mengurangi jumlah data yang perlu ditulis ke disk dalam satu waktu.


Before
   ```bash
   GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=dd1fe6bb-8476-4635-b233-1f8692284710 resume_offset=78254080"
   ```
after
   ```bash
   GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=dd1fe6bb-8476-4635-b233-1f8692284710 resume_offset=78254080 zswap.enabled=1 zswap.compressor=lz4 zswap.max_pool_percent=20"
   ```

hibernate config
