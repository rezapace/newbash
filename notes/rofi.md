Tentu, berikut adalah instruksi yang lebih rapi dan terstruktur lengkap dengan deskripsi langkah demi langkah untuk mengonfigurasi Rofi agar menampilkan mode `window` terlebih dahulu sebelum `drun` dan menetapkan key binding untuk menjalankannya.

### 1. Edit Konfigurasi Rofi

Pertama, kita akan mengedit file konfigurasi Rofi untuk mengatur mode kombinasi dan menerapkan tema yang diinginkan.

#### Langkah-langkah:

1. **Buka Terminal:**
   Buka terminal di Linux Mint.

2. **Edit File Konfigurasi Rofi:**
   Jalankan perintah berikut untuk membuka file konfigurasi Rofi menggunakan nano:
   ```bash
   nano ~/.config/rofi/config.rasi
   ```

3. **Isi File Konfigurasi:**
   Salin dan tempelkan konfigurasi berikut ke dalam file:
   ```plaintext
   configuration {
       combi-modi: "window,drun";
   }

   @theme "/home/r/.local/share/rofi/themes/rounded-gray-dark.rasi"
   ```

   - **configuration:** Blok ini menentukan mode kombinasi yang akan digunakan oleh Rofi. Dalam hal ini, `combi-modi` diatur untuk menampilkan `window` terlebih dahulu diikuti oleh `drun`.
   - **@theme:** Baris ini menetapkan tema yang akan digunakan oleh Rofi. Pastikan path ke file tema benar.

4. **Simpan dan Keluar:**
   Simpan perubahan dan keluar dari nano:
   - Tekan `Ctrl+O` untuk menyimpan file.
   - Tekan `Enter` untuk mengonfirmasi.
   - Tekan `Ctrl+X` untuk keluar dari nano.

### 2. Tambah Shortcut Keyboard untuk Rofi

Sekarang kita akan menambahkan shortcut keyboard untuk menjalankan Rofi dengan mode kombinasi yang telah dikonfigurasi.

#### Langkah-langkah:

1. **Buka Pengaturan Keyboard:**
   - Buka **Menu** -> **Preferences** -> **Keyboard**.

2. **Pilih Tab Shortcuts:**
   - Pilih tab **Shortcuts**.

3. **Tambah Custom Shortcut:**
   - Klik **Custom Shortcuts**.
   - Klik tombol **Add custom shortcut**.

4. **Isi Detil Shortcut:**
   - **Name:** Beri nama shortcut, misalnya "Rofi Combi".
   - **Command:** Masukkan perintah berikut untuk menjalankan Rofi dengan mode kombinasi:
     ```bash
     rofi -show combi
     ```

5. **Tetapkan Kombinasi Tombol:**
   - Klik pada kolom shortcut untuk menambahkan kombinasi tombol yang akan digunakan, misalnya `Ctrl+Alt+Space`.

6. **Simpan Shortcut:**
   - Klik **Add** untuk menyimpan shortcut.

### 3. Uji Konfigurasi

Terakhir, kita akan menguji konfigurasi Rofi untuk memastikan semuanya berfungsi dengan baik.

#### Langkah-langkah:

1. **Jalankan Rofi:**
   - Tekan kombinasi tombol yang telah Anda tetapkan, misalnya `Ctrl+Alt+Space`.

2. **Periksa Mode Kombinasi:**
   - Pastikan Rofi menampilkan mode `window` terlebih dahulu. Anda seharusnya dapat mengetik untuk mencari dan memilih jendela yang terbuka.
   - Jika Anda tidak menemukan jendela yang diinginkan, Anda dapat menekan tombol `Esc` dan Rofi akan menampilkan mode `drun` untuk meluncurkan aplikasi.

Dengan mengikuti langkah-langkah ini, Anda sekarang memiliki Rofi yang dikonfigurasi untuk menampilkan mode window walker terlebih dahulu, diikuti oleh mode aplikasi launcher (drun). Ini memungkinkan Anda untuk dengan mudah beralih antara jendela yang terbuka dan meluncurkan aplikasi baru dari satu antarmuka.


# menjalankan terminal command 
Jika Anda menggunakan Linux Mint, Anda mungkin menggunakan `x-terminal-emulator`, `gnome-terminal`, `xfce4-terminal`, atau terminal lainnya yang sudah terinstal di sistem Anda. Mari kita coba beberapa opsi ini untuk memastikan bahwa kita dapat membuka terminal dengan perintah `sudo`.

1. **Edit Skrip `run_as_admin.sh`:**

   Buka skrip `run_as_admin.sh`:

   ```bash
   nano /home/r/Documents/Backups/run_as_admin.sh
   ```

   Ubah konten skrip menjadi seperti ini, mencoba beberapa terminal yang berbeda:

   ```bash
   #!/bin/bash
   if [ -z "$1" ]; then
     echo "Usage: $0 <command>"
     exit 1
   fi

   # Uncomment one of the following lines depending on the terminal you have installed
   # gnome-terminal -- sudo bash -c "$*"
   # x-terminal-emulator -e "sudo bash -c '$*'"
   # xfce4-terminal -e "sudo bash -c '$*'"
   mate-terminal -e "sudo bash -c '$*'"
   ```

   Simpan dan tutup editor (Ctrl+X, Y, Enter).

   Anda dapat mencoba masing-masing baris terminal yang berbeda dengan mengomentari (menambahkan `#` di depan) baris lainnya.

2. **Uji Skrip:**

   Coba jalankan skrip secara langsung dari terminal untuk memastikan terminal yang Anda pilih berfungsi. Misalnya:

   ```bash
   /home/r/Documents/Backups/run_as_admin.sh "ls"
   ```

3. **Perbarui Konfigurasi Rofi:**

   Pastikan konfigurasi Rofi Anda sudah benar dengan menambahkan `combi` ke dalam daftar `modi`. Edit file `~/.config/rofi/config.rasi`:

   ```bash
   nano ~/.config/rofi/config.rasi
   ```

   Tambahkan atau modifikasi bagian berikut:

   ```rasi
   configuration {
       combi-modi: "window,drun,run";
       run-command: "/home/r/Documents/Backups/run_as_admin.sh {cmd}";
   }

   modi: "window,run,drun,combi";

   @theme "/home/r/.local/share/rofi/themes/rounded-gray-dark.rasi"
   ```

   Simpan dan tutup editor (Ctrl+X, Y, Enter).

4. **Jalankan Rofi:**

   Jalankan Rofi dengan konfigurasi baru Anda:

   ```bash
   rofi -show combi
   ```

5. **Penggunaan:**

   Saat Rofi muncul, Anda bisa mengetikkan perintah yang ingin dijalankan dengan hak administrator.

Dengan langkah-langkah ini, Anda sekarang seharusnya dapat menggunakan Rofi untuk menjalankan perintah terminal dengan hak administrator menggunakan skrip `run_as_admin.sh`. Pastikan skrip tersebut memiliki izin eksekusi dan path yang benar dalam konfigurasi Rofi Anda.