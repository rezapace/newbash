#!/bin/zsh

# Memastikan dua argumen diberikan
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <folder_name> <zip_filename>"
    exit 1
fi

folder_name=$1
zip_filename=$2

# Memastikan folder yang akan di-zip ada
if [ ! -d "$folder_name" ]; then
    echo "Error: Folder '$folder_name' tidak ditemukan."
    exit 1
fi

# Melakukan kompresi menggunakan zip -r
zip -r "$zip_filename" "$folder_name"

echo "Folder '$folder_name' telah di-zip menjadi '$zip_filename'."
