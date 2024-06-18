### Memperbaiki Masalah Bluetooth di Linux Mint 21

Jika Anda mengalami masalah dengan koneksi Bluetooth setelah melakukan pembaruan di Linux Mint 21, panduan berikut akan membantu Anda memperbaikinya. Masalah ini sering terjadi setelah pembaruan paket `bluez` ke versi yang lebih baru, yang menyebabkan ketidakstabilan koneksi Bluetooth.

#### Langkah 1: Instalasi Paket-Paket yang Diperlukan

1. Buka terminal dan jalankan perintah berikut untuk menginstal paket-paket yang diperlukan:

   ```bash
   sudo apt install libfdk-aac2 libldacbt-{abr,enc}2 libopenaptx0
   sudo apt install libspa-0.2-bluetooth pipewire-audio-client-libraries pipewire-media-session wireplumber
   ```

2. Aktifkan dan mulai ulang layanan `wireplumber`:

   ```bash
   systemctl --user --now enable wireplumber.service
   systemctl --user --now restart wireplumber.service
   ```

#### Langkah 2: Menurunkan Versi Paket Bluez

Masalah koneksi Bluetooth yang tidak stabil sering kali disebabkan oleh pembaruan ke versi `bluez` yang lebih baru. Untuk memperbaikinya, kita perlu menurunkan versi paket `bluez`, `bluez-cups`, dan `bluez-obexd` ke versi sebelumnya.

1. Buka **Synaptic Package Manager**.
2. Cari paket `bluez`, `bluez-cups`, dan `bluez-obexd`.
3. Pilih setiap paket satu per satu, buka menu "Package" di bagian atas, lalu pilih "Force Version".
4. Pilih versi `5.64-0ubuntu1 (jammy)` dan terapkan perubahan.

#### Langkah 3: Mengunduh dan Menginstal Firmware Bluetooth

Untuk beberapa perangkat, Anda mungkin perlu mengunduh firmware Bluetooth tambahan.

1. Buka terminal dan pindah ke direktori firmware:

   ```bash
   cd /lib/firmware/brcm
   ```

2. Unduh firmware yang diperlukan:

   ```bash
   sudo wget https://github.com/winterheart/broadcom-bt-firmware/raw/master/brcm/BCM43142A0-105b-e065.hcd
   ```

3. Restart komputer Anda:

   ```bash
   sudo reboot
   ```

#### Catatan Tambahan

- **Volume**: Setelah memulai ulang layanan `wireplumber`, volume Bluetooth mungkin akan diatur ke 100%. Harap berhati-hati agar tidak terlalu keras.
- **Tandai sebagai "Solved"**: Jika langkah-langkah di atas berhasil memperbaiki masalah Anda, tandai postingan terkait sebagai "Solved" di forum untuk membantu pengguna lain.

Dengan mengikuti langkah-langkah ini, Anda seharusnya dapat memperbaiki masalah koneksi Bluetooth di Linux Mint 21. Jika Anda masih mengalami kesulitan, jangan ragu untuk mencari bantuan lebih lanjut di forum pengguna Linux Mint atau komunitas terkait.


fix vluetooth

sudo apt install libfdk-aac2 libldacbt-{abr,enc}2 libopenaptx0
sudo apt install libspa-0.2-bluetooth pipewire-audio-client-libraries pipewire-media-session- wireplumber
systemctl --user --now enable wireplumber.service
systemctl --user --now restart wireplumber.service

Re: Bluetooth Issues in Linux Mint 21
Post by janivee » Fri Aug 26, 2022 6:28 am

Same here, before the update bluetooth amplifier worked fine, but after the update it won't appear in the Sound Settings.
Bluetooth manager seems to work fine (connects easily to the device and so on).

I am with the Pipewire, so this might be the reason why Mint is not picking it up perfectly without some "systemctl commands".

===
I did this, all might not be needed:
CODE: SELECT ALL

sudo apt install libfdk-aac2 libldacbt-{abr,enc}2 libopenaptx0
sudo apt install libspa-0.2-bluetooth pipewire-audio-client-libraries pipewire-media-session- wireplumber
systemctl --user --now enable wireplumber.service
systemctl --user --now restart wireplumber.service
Remember that volume will be 100% when started! IT MIGHT BE LOUD!

If it works, mark as "solved", if you got help from this.


sudo apt install libfdk-aac2 libldacbt-{abr,enc}2 libopenaptx0
sudo apt install libspa-0.2-bluetooth pipewire-audio-client-libraries pipewire-media-session- wireplumber
systemctl --user --now enable wireplumber.service
systemctl --user --now restart wireplumber.service

https://forums.linuxmint.com/viewtopic.php?t=379258

https://forums.linuxmint.com/viewtopic.php?t=379415

di ubah ke version
5.64-0ubuntu1 (jammy)

Kesimpulan dari diskusi di forum tersebut adalah bahwa masalah koneksi Bluetooth yang tidak stabil pada perangkat Linux Mint 21.2 disebabkan oleh pembaruan paket bluez ke versi 5.64-0ubuntu1.1. Solusi yang berhasil untuk memperbaiki masalah ini adalah dengan mengembalikan paket bluez, bluez-cups, dan bluez-obexd ke versi sebelumnya, yaitu 5.64-0ubuntu1. Hal ini dapat dilakukan melalui Synaptic Package Manager dengan memilih paket-paket tersebut satu per satu, kemudian menggunakan opsi "force version" untuk menurunkan versi ke versi yang lebih lama (jammy).

Langkah-langkahnya adalah sebagai berikut:
1. Buka Synaptic Package Manager.
2. Cari paket bluez, bluez-cups, dan bluez-obexd.
3. Pilih setiap paket satu per satu, buka menu "Package" di bagian atas, lalu pilih "Force Version".
4. Pilih versi 5.64-0ubuntu1 (jammy) dan terapkan perubahan.

cd /lib/firmware/brcm
sudo wget https://github.com/winterheart/broadcom-bt-firmware/raw/master/brcm/BCM43142A0-105b-e065.hcd
sudo reboot


fix bluetooth