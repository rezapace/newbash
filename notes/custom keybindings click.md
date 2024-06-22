Baik, berikut ini adalah langkah-langkah yang lebih jelas untuk mengonfigurasi tombol Insert pada keyboard Anda agar bertindak seperti right-click (menu konteks) di Ubuntu menggunakan `xmodmap`:

### Langkah-langkah:

1. **Identifikasi Keycode untuk Tombol Insert:**
   Pertama, Anda perlu mengetahui keycode yang terkait dengan tombol Insert pada keyboard Anda. Dari output yang Anda berikan, keycode untuk Insert adalah 90. Anda bisa menggunakan perintah `xev` untuk mengetahui keycode ini:
   ```
   xev | grep keycode
   ```
   Fokuskan jendela yang muncul, tekan tombol Insert, dan perhatikan keluaran untuk menemukan nilai keycode-nya.

2. **Membuat atau Mengedit File `~/.Xmodmap`:**
   - Buat atau edit file `~/.Xmodmap` jika belum ada. Anda bisa menggunakan editor teks seperti `nano` atau `gedit`:
     ```
     nano ~/.Xmodmap
     ```
   - Tambahkan baris berikut ke dalam file `~/.Xmodmap`:
     ```
     keycode 90 = Menu
     ```
   - Simpan perubahan dengan menekan `Ctrl + O`, lalu tekan `Enter` untuk menyimpan, dan terakhir `Ctrl + X` untuk keluar dari editor.

3. **Menerapkan Konfigurasi `xmodmap`:**
   - Jalankan perintah berikut untuk menerapkan konfigurasi dari `~/.Xmodmap`:
     ```
     xmodmap ~/.Xmodmap
     ```

4. **Uji Coba:**
   - Setelah menerapkan konfigurasi, tekan tombol Insert pada keyboard Anda. Sekarang seharusnya tombol tersebut akan memunculkan menu konteks (right-click) di lokasi kursor, sama seperti ketika Anda melakukan right-click menggunakan mouse.

### Catatan Tambahan:

- Pastikan Anda telah memiliki `xmodmap` terinstal di sistem Ubuntu Anda. Biasanya sudah terpasang secara default, tetapi jika tidak, Anda dapat menginstalnya dengan perintah:
  ```
  sudo apt update
  sudo apt install x11-xserver-utils
  ```
- Menggunakan `xmodmap` memungkinkan Anda untuk menyesuaikan pengaturan keyboard Anda sesuai keinginan. Pastikan untuk menyimpan konfigurasi `~/.Xmodmap` agar pengaturan tetap persisten setelah reboot.

Dengan mengikuti langkah-langkah di atas, Anda seharusnya dapat mengonfigurasi tombol Insert pada keyboard Anda untuk bertindak sebagai right-click di Ubuntu menggunakan `xmodmap`.