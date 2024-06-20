Untuk menonaktifkan layanan yang memakan waktu lama saat boot berdasarkan output dari `systemd-analyze blame`, Anda dapat menggunakan perintah `systemctl disable` untuk masing-masing layanan tersebut. Berikut adalah langkah-langkah yang dapat Anda ikuti:

1. **Nonaktifkan Layanan Docker**:
    ```bash
    sudo systemctl disable docker.service
    ```

2. **Nonaktifkan Layanan MySQL**:
    ```bash
    sudo systemctl disable mysql.service
    ```

3. **Nonaktifkan Layanan Podman Restart**:
    ```bash
    sudo systemctl disable podman-restart.service
    ```

Dengan perintah di atas, layanan-layanan tersebut tidak akan otomatis dimulai saat sistem booting. Namun, jika Anda membutuhkan layanan tersebut, Anda masih bisa menjalankannya secara manual dengan perintah `systemctl start <nama-layanan>`.

Untuk memastikan layanan tidak berjalan pada boot berikutnya, Anda dapat memeriksa statusnya menggunakan perintah berikut:
```bash
systemctl is-enabled docker.service
systemctl is-enabled mysql.service
systemctl is-enabled podman-restart.service
```

Jika Anda perlu mengaktifkan kembali layanan tersebut di masa mendatang, Anda bisa menggunakan perintah:
```bash
sudo systemctl enable docker.service
sudo systemctl enable mysql.service
sudo systemctl enable podman-restart.service
```

Pastikan untuk mempertimbangkan dampak dari menonaktifkan layanan ini terhadap sistem dan aplikasi yang Anda gunakan, terutama jika layanan tersebut penting untuk pekerjaan Anda.