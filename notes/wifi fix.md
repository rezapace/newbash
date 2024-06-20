Untuk mengatasi masalah ketika Wi-Fi tidak terhubung dan tidak ada daftar jaringan Wi-Fi yang aktif, berikut beberapa langkah yang bisa diambil selain merestart NetworkManager:

### 1. Menghidupkan/Mematikan Wi-Fi
Terkadang mematikan dan menghidupkan kembali Wi-Fi dapat membantu menemukan jaringan yang tersedia.
```bash
nmcli radio wifi off
nmcli radio wifi on
```

### 2. Memindai Ulang Jaringan Wi-Fi
Memindai ulang jaringan Wi-Fi dapat membantu menemukan jaringan yang tersedia.
```bash
nmcli device wifi rescan
```

### 3. Menghubungkan ke Wi-Fi Secara Manual
Coba hubungkan secara manual ke jaringan Wi-Fi yang diinginkan.
```bash
nmcli device wifi connect <SSID> password <PASSWORD>
```

### 4. Memeriksa Status NetworkManager
Pastikan NetworkManager sedang berjalan dengan memeriksa statusnya.
```bash
systemctl status NetworkManager
```

Jika NetworkManager tidak berjalan, Anda dapat memulainya dengan:
```bash
sudo systemctl start NetworkManager
```

### 5. Mengatasi Masalah Driver Wi-Fi
Kadang-kadang, masalah ini bisa disebabkan oleh driver Wi-Fi. Restarting driver Wi-Fi bisa menjadi solusi.
```bash
sudo modprobe -r <nama_driver_wifi>
sudo modprobe <nama_driver_wifi>
```
Anda bisa mencari tahu nama driver Wi-Fi dengan perintah:
```bash
lspci -k | grep -A 3 -i "network"
```

### 6. Memeriksa Log Sistem
Periksa log sistem untuk melihat apa yang terjadi saat Anda mencoba menghubungkan ke Wi-Fi.
```bash
journalctl -xe
```

### 7. Menggunakan Tool Lain
Jika `nmcli` tidak berhasil, Anda bisa mencoba menggunakan tool lain seperti `wicd` atau `iwconfig`:
- **Wicd**:
  ```bash
  sudo apt install wicd-curses
  sudo wicd-curses
  ```
- **Iwconfig**:
  ```bash
  sudo iwconfig wlan0 essid <SSID>
  sudo iwconfig wlan0 key s:<PASSWORD>
  sudo dhclient wlan0
  ```

Jika langkah-langkah di atas tidak menyelesaikan masalah, Anda mungkin perlu kembali merestart NetworkManager:
```bash
sudo systemctl restart NetworkManager
```

Dengan mencoba langkah-langkah di atas, Anda mungkin dapat menemukan solusi yang lebih efisien tanpa harus selalu merestart NetworkManager.