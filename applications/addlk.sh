#!/bin/bash

# Meminta nama aplikasi dan link dari pengguna
read -p "Masukkan nama aplikasi: " app_name
read -p "Masukkan link: " app_link

# Membuat konten untuk file .desktop
desktop_content="[Desktop Entry]\nVersion=1.0\nTerminal=false\nType=Application\nName=$app_name\nExec=/usr/bin/google-chrome --new-tab $app_link\nIcon=chrome-fmgjjmmmlfnkbppncabfkddbjimcfncm-Default\nStartupWMClass=Google-chrome"

# Menyimpan konten ke file .desktop
echo -e "$desktop_content" > "/home/r/.local/share/applications/app chrome/$app_name.desktop"

echo "File $app_name.desktop telah berhasil dibuat di /home/r/.local/share/applications/app chrome."

