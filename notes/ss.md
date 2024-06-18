### Menginstal dan Mengonfigurasi Flameshot untuk Screenshot di Linux Mint

Berikut adalah langkah-langkah terperinci untuk menginstal dan mengonfigurasi **Flameshot** sebagai alat tangkapan layar di Linux Mint, serta cara membuat skrip shell untuk menyimpan tangkapan layar dan menyalinnya ke clipboard.

#### Langkah 1: Instalasi Flameshot

1. Buka terminal.
2. Jalankan perintah berikut untuk menginstal Flameshot:

   ```bash
   sudo apt install flameshot
   ```

#### Langkah 2: Membuat Skrip Shell untuk Tangkapan Layar

1. Buat direktori untuk menyimpan skrip jika belum ada:

   ```bash
   mkdir -p /home/r/Documents/Backups
   ```

2. Buat file skrip dengan nama `ss.sh`:

   ```bash
   nano /home/r/Documents/Backups/ss.sh
   ```

3. Masukkan isi skrip berikut ke dalam file `ss.sh`:

   ```bash
   #!/bin/bash
   /usr/bin/flameshot gui -p /tmp --raw | xclip -selection clipboard -t image/png
   ```

4. Simpan dan keluar dari editor teks (Ctrl+O untuk menyimpan, Ctrl+X untuk keluar).

5. Jadikan skrip tersebut dapat dieksekusi:

   ```bash
   chmod +x /home/r/Documents/Backups/ss.sh
   ```

#### Langkah 3: Menambahkan Pintasan Keyboard untuk Skrip

1. Buka **Keyboard** settings di Linux Mint.
2. Pilih tab **Shortcuts**.
3. Klik **Custom Shortcuts**.
4. Klik tombol **Add** untuk menambahkan pintasan baru.
   - **Name**: Ambil Tangkapan Layar
   - **Command**: `/home/r/Documents/Backups/ss.sh`

5. Klik **Add**.
6. Klik pada kolom **Shortcut** untuk pintasan baru dan tekan kombinasi tombol yang ingin Anda gunakan (misalnya, `Ctrl+Alt+S`).

#### Langkah 4: Menguji Konfigurasi

1. Tekan kombinasi tombol yang telah Anda atur untuk pintasan.
2. Flameshot akan terbuka dan memungkinkan Anda untuk mengambil tangkapan layar.
3. Tangkapan layar akan disimpan di direktori `/tmp` dan salinan gambar akan berada di clipboard.

#### Penjelasan Skrip

- `#!/bin/bash`: Menentukan bahwa skrip ini adalah skrip bash.
- `/usr/bin/flameshot gui -p /tmp --raw`: Memanggil Flameshot dalam mode GUI untuk mengambil tangkapan layar, menyimpannya sementara di direktori `/tmp`.
- `| xclip -selection clipboard -t image/png`: Menyalin tangkapan layar langsung ke clipboard sebagai gambar PNG.

Dengan langkah-langkah ini, Anda telah menginstal Flameshot, membuat skrip untuk mengambil tangkapan layar, dan mengatur pintasan keyboard untuk menjalankan skrip tersebut. Sekarang, Anda dapat dengan mudah mengambil tangkapan layar dan menyalinnya ke clipboard hanya dengan menekan kombinasi tombol yang telah Anda tetapkan.