#!/bin/bash

# Meminta input nama aplikasi dan perintah eksekusi dari pengguna
read -p "Masukkan nama aplikasi: " app_name
read -p "Masukkan perintah eksekusi (Exec): " app_exec

# Membuat konten untuk file .desktop
desktop_content="[Desktop Entry]\nVersion=1.0\nType=Application\nName=$app_name\nExec=$app_exec\nIcon=folder\nTerminal=false"

# Menyimpan konten ke file .desktop
echo -e "$desktop_content" > "/home/r/.local/share/applications/app system/$app_name.desktop"

echo "File $app_name.desktop telah berhasil dibuat di /home/r/.local/share/applications/app system."
