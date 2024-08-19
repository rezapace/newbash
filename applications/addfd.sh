#!/bin/bash

# Meminta input nama aplikasi dan path dari pengguna
read -p "Masukkan nama aplikasi: " app_name
read -p "Masukkan path aplikasi: " app_path

# Menambahkan 'caja' di depan path
app_exec="caja $app_path"

# Membuat konten untuk file .desktop
desktop_content="[Desktop Entry]\nVersion=1.0\nType=Application\nName=$app_name\nExec=$app_exec\nIcon=folder\nTerminal=false\n"

# Menyimpan konten ke file .desktop
mkdir -p "/home/r/.local/share/applications/folder"
echo -e "$desktop_content" > "/home/r/.local/share/applications/folder/$app_name.desktop"

echo "File $app_name.desktop telah berhasil dibuat di /home/r/.local/share/applications/folder."

