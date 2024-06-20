Untuk membuat shortcut keyboard yang dapat menampilkan terminal yang sudah terbuka, Anda bisa menggunakan alat bantu seperti `wmctrl` untuk memanipulasi jendela di Linux. Berikut adalah langkah-langkah untuk membuat shortcut keyboard yang menampilkan terminal yang sudah terbuka:

### 1. Instal `wmctrl`
Pertama, Anda perlu menginstal `wmctrl` jika belum terinstal.

```bash
sudo apt-get install wmctrl
```

### 2. Buat Skrip untuk Menampilkan Terminal
Buat skrip bash yang akan menampilkan terminal yang sudah terbuka.

#### Langkah-langkah:
1. Buat file skrip baru, misalnya `show_terminal.sh`.

    ```bash
    nano ~/show_terminal.sh
    ```

2. Tambahkan skrip berikut ke dalam file tersebut:

    ```bash
    #!/bin/bash

    # Nama jendela terminal (sesuaikan dengan nama terminal Anda, misalnya gnome-terminal)
    terminal="gnome-terminal"

    # Mencari jendela terminal yang sedang berjalan
    wmctrl -xa $terminal || $terminal &
    ```

    **Catatan:** Ganti `gnome-terminal` dengan nama terminal yang Anda gunakan jika berbeda.

3. Simpan dan tutup file.
4. Berikan izin eksekusi pada skrip:

    ```bash
    chmod +x ~/show_terminal.sh
    ```

### 3. Buat Shortcut Keyboard
Sekarang, buat shortcut keyboard untuk menjalankan skrip tersebut.

#### Langkah-langkah:
1. Buka `Keyboard` dari menu Settings.
2. Pilih tab `Shortcuts`.
3. Pilih `Custom Shortcuts`.
4. Klik tombol `Add` untuk menambahkan shortcut baru.
5. Isi form dengan:
    - Name: **Show Terminal**
    - Command: `/home/username/show_terminal.sh` (ganti `username` dengan nama pengguna Anda)
6. Klik `Add`.
7. Klik pada kolom `Shortcut` untuk `Show Terminal` dan tekan kombinasi tombol yang diinginkan, misalnya `Ctrl+T`.

### 4. Uji Shortcut
Tekan `Ctrl+T` untuk memastikan shortcut berfungsi dengan benar dan menampilkan terminal yang sudah terbuka.

Dengan mengikuti langkah-langkah di atas, Anda sekarang memiliki shortcut keyboard yang menampilkan terminal yang sudah terbuka menggunakan `Ctrl+T`. Jika terminal belum berjalan, skrip akan membuka terminal baru.


Baik, jika Anda menggunakan Linux Mint Mate, mungkin Anda menggunakan terminal yang berbeda, seperti `mate-terminal`. Anda dapat memeriksa nama terminal yang sedang digunakan dengan cara berikut:

### Langkah-langkah untuk Memeriksa Nama Terminal:
1. Buka terminal Anda.
2. Jalankan perintah berikut untuk mengetahui terminal yang sedang digunakan:

    ```bash
    echo $TERM
    ```

Namun, `echo $TERM` hanya menampilkan tipe terminal, bukan nama program. Nama program biasanya `mate-terminal` untuk Mate. Jadi, kita akan mencoba `mate-terminal`.

### Perbarui Skrip:
Perbarui skrip `show_terminal.sh` untuk menggunakan `mate-terminal` sebagai terminal yang digunakan.

#### Langkah-langkah:
1. Buka file skrip Anda:

    ```bash
    nano /home/r/Documents/Backups/show_terminal.sh
    ```

2. Ubah konten skrip menjadi:

    ```bash
    #!/bin/bash

    # Nama jendela terminal untuk Mate
    terminal="mate-terminal"

    # Mencari jendela terminal yang sedang berjalan
    wmctrl -xa $terminal || $terminal &
    ```

3. Simpan dan tutup file.
4. Pastikan skrip memiliki izin eksekusi:

    ```bash
    chmod +x /home/r/Documents/Backups/show_terminal.sh
    ```

### Uji Skrip:
Jalankan skrip dari terminal untuk memastikan bekerja dengan baik:

```bash
/home/r/Documents/Backups/show_terminal.sh
```

Jika masih ada masalah, Anda dapat memeriksa apakah `mate-terminal` terinstal dengan menjalankan:

```bash
which mate-terminal
```

Jika `mate-terminal` tidak ditemukan, pastikan terinstal dengan:

```bash
sudo apt-get install mate-terminal
```

### Buat Shortcut Keyboard:
Setelah memastikan skrip berfungsi, buat shortcut keyboard seperti sebelumnya:

1. Buka `Keyboard` dari menu Settings.
2. Pilih tab `Shortcuts`.
3. Pilih `Custom Shortcuts`.
4. Klik tombol `Add` untuk menambahkan shortcut baru.
5. Isi form dengan:
    - **Name**: Show Terminal
    - **Command**: `/home/r/Documents/Backups/show_terminal.sh`
6. Klik `Add`.
7. Klik pada kolom `Shortcut` untuk `Show Terminal` dan tekan kombinasi tombol yang diinginkan, misalnya `Ctrl+T`.

Dengan langkah-langkah ini, Anda seharusnya dapat menggunakan shortcut keyboard `Ctrl+T` untuk menampilkan terminal yang sudah terbuka atau membuka terminal baru jika belum ada yang terbuka.