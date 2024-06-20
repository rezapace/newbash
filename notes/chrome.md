Baik, jika Anda menggunakan Linux Mint, langkah-langkah untuk mengatur Chrome agar bisa membuka folder setelah download dan menjalankan Chrome tanpa harus memasukkan password tetap serupa, hanya saja ada beberapa penyesuaian yang perlu dilakukan. Berikut panduannya:

### Membuka Folder Otomatis Setelah Download di Chrome
Untuk membuka folder secara otomatis setelah download selesai, Anda bisa menggunakan ekstensi seperti "Download Auto Open" atau mengatur skrip otomatisasi. Berikut langkah menggunakan ekstensi:

1. **Menggunakan Ekstensi:**
   1. Buka Google Chrome.
   2. Pergi ke [Chrome Web Store](https://chrome.google.com/webstore).
   3. Cari ekstensi "Download Auto Open".
   4. Klik "Add to Chrome" untuk menambahkan ekstensi tersebut.
   5. Setelah ekstensi terpasang, biasanya secara default akan membuka folder setelah download selesai.

### Menjalankan Chrome Tanpa Memasukkan Password
Untuk menjalankan Chrome tanpa harus memasukkan password setiap kali, Anda bisa memanfaatkan pengelola kata sandi bawaan Chrome atau menggunakan skrip otomatisasi.

#### Menggunakan Pengelola Kata Sandi Bawaan:
1. Buka Chrome.
2. Klik ikon tiga titik di pojok kanan atas, pilih "Settings".
3. Di bagian "Autofill", pilih "Passwords".
4. Pastikan "Offer to save passwords" dan "Auto Sign-in" diaktifkan.

#### Menggunakan Skrip Otomatisasi dengan Selenium di Linux Mint:
1. **Install Selenium dan ChromeDriver:**
   Buka terminal dan jalankan perintah berikut untuk menginstal Selenium dan ChromeDriver:
   ```bash
   sudo apt update
   sudo apt install -y python3-pip
   pip3 install selenium
   sudo apt install -y chromium-chromedriver
   ```

2. **Membuat Skrip Otomatisasi:**
   Buat skrip Python seperti berikut untuk otomatisasi login:
   ```python
   from selenium import webdriver
   from selenium.webdriver.chrome.service import Service
   from selenium.webdriver.common.by import By
   from selenium.webdriver.chrome.options import Options

   # Lokasi dari ChromeDriver
   chrome_driver_path = "/usr/lib/chromium-browser/chromedriver"

   # Konfigurasi Chrome Options
   chrome_options = Options()
   chrome_options.add_argument("--start-maximized")

   # Membuat service object
   service = Service(chrome_driver_path)

   # Membuka Chrome
   driver = webdriver.Chrome(service=service, options=chrome_options)

   # Buka halaman login
   driver.get("https://example.com/login")

   # Isi username dan password
   username = driver.find_element(By.ID, "username")
   password = driver.find_element(By.ID, "password")

   username.send_keys("your_username")
   password.send_keys("your_password")

   # Klik tombol login
   login_button = driver.find_element(By.ID, "login_button")
   login_button.click()
   ```

3. **Jalankan Skrip:**
   Simpan skrip di atas sebagai `login_script.py` dan jalankan dengan perintah berikut:
   ```bash
   python3 login_script.py
   ```

Dengan skrip ini, Chrome akan dibuka secara otomatis, mengisi detail login, dan mengklik tombol login. Pastikan untuk mengganti `your_username`, `your_password`, dan elemen ID sesuai dengan yang ada di halaman login Anda.

Dengan mengikuti langkah-langkah di atas, Anda bisa membuat Chrome membuka folder setelah download dan otomatis login tanpa harus memasukkan password secara manual.