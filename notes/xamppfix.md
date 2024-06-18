Berikut adalah langkah-langkah terperinci untuk mengatasi masalah yang Anda hadapi dan menginstal XAMPP, disertai dengan penjelasan singkat setiap perintah.

### Mengatasi Masalah dengan PHP dan Apache

1. **Instalasi Modul PHP untuk Apache**

   Untuk mengatasi masalah dengan layanan PHP dan Apache, Anda perlu menginstal modul `libapache2-mod-php8.1`. Buka terminal dan jalankan perintah berikut:

   ```sh
   sudo apt install libapache2-mod-php8.1
   ```

   Perintah ini menginstal modul PHP versi 8.1 untuk Apache.

2. **Memulai Ulang Layanan Apache**

   Setelah menginstal modul PHP, Anda perlu memulai ulang layanan Apache agar perubahan dapat diterapkan. Jalankan perintah berikut:

   ```sh
   sudo systemctl restart apache2
   ```

   Perintah ini memulai ulang layanan Apache, memastikan bahwa modul PHP yang baru diinstal dimuat dengan benar.

### Menginstal XAMPP

Untuk menginstal XAMPP, ikuti langkah berikut:

**Unduh dan Jalankan Skrip Instalasi XAMPP**

   Jalankan perintah berikut di terminal:

   ```sh
   bash <(curl -s https://raw.githubusercontent.com/rezapace/newlinux/main/xampp.sh)
   ```

   Perintah ini menggunakan `curl` untuk mengunduh skrip instalasi XAMPP dari GitHub dan langsung mengeksekusinya dengan `bash`.
