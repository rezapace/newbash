Menggunakan Ramdisk untuk Rofi
Buat Ramdisk:

bash
Copy code
sudo mkdir /mnt/ramdisk
sudo mount -t tmpfs -o size=1G tmpfs /mnt/ramdisk
Ini akan membuat Ramdisk sebesar 1GB. Anda dapat menyesuaikan ukuran sesuai kebutuhan.
Pindahkan Konfigurasi Rofi ke Ramdisk:

bash
Copy code
cp -r ~/.config/rofi /mnt/ramdisk/
Salin seluruh direktori konfigurasi Rofi dari ~/.config/rofi ke Ramdisk di /mnt/ramdisk.
Buat Symbolic Link:

bash
Copy code
rm -rf ~/.config/rofi
ln -s /mnt/ramdisk/rofi ~/.config/rofi
Hapus direktori konfigurasi asli Rofi di ~/.config/rofi dan buat symbolic link ke Ramdisk.

