#!/bin/bash

# Menanyakan direktori
read -p "Masukkan path ke direktori: " DIR

# Memeriksa apakah direktori ada
if [ ! -d "$DIR" ]; then
  echo "Direktori tidak ditemukan!"
  exit 1
fi

# Menghitung jumlah file di dalam direktori
file_count=$(ls -1q "$DIR"/* | wc -l)
echo "Ada $file_count file di dalam direktori."

# Menanyakan apakah ingin melanjutkan rename
read -p "Apakah Anda ingin merename file-file tersebut? (y/n): " confirm
if [ "$confirm" != "y" ]; then
  echo "Proses dibatalkan."
  exit 0
fi

# Menanyakan format rename
read -p "Masukkan format rename (misal: reza): " format

# Menanyakan dari nomor berapa renaming dimulai
read -p "Masukkan nomor awal untuk rename: " start_num

# Inisialisasi counter
counter=$start_num

# Loop melalui semua file dalam direktori
for file in "$DIR"/*; do
  # Tentukan ekstensi file
  ext="${file##*.}"
  # Rename file
  mv "$file" "$DIR/$format($counter).$ext"
  # Increment counter
  ((counter++))
done

echo "Rename selesai. $file_count file telah diubah namanya."
