#!/bin/zsh

# Meminta nama file ZIP dari pengguna
read -p "Masukkan nama file ZIP: " zip_filename

# Meminta nama folder yang akan di-zip dari pengguna
read -p "Masukkan nama folder yang akan di-zip: " folder_name

# Memastikan folder yang akan di-zip ada
if [ ! -d "$folder_name" ]; then
    echo "Error: Folder '$folder_name' tidak ditemukan."
    exit 1
fi

# Melakukan kompresi menggunakan zip -r
zip -r "$zip_filename" "$folder_name"

echo "Folder '$folder_name' telah di-zip menjadi '$zip_filename'."
