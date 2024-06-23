#!/bin/bash

# Menanyakan path file gambar yang ingin diupload
read -p "Masukkan path file gambar yang ingin diupload: " IMAGE_PATH

# Mengubah path relatif ke path absolut
ABSOLUTE_IMAGE_PATH=$(realpath "$IMAGE_PATH" 2>/dev/null)

# Memeriksa apakah file ada
if [[ ! -f "$ABSOLUTE_IMAGE_PATH" ]]; then
  echo "File tidak ditemukan! Pastikan path benar."
  exit 1
fi

# Endpoint ImgBB untuk upload
UPLOAD_URL="https://api.imgbb.com/1/upload"
API_KEY="8f3bbe041f76a22f7aa7a5f44b53e718"

# Upload gambar menggunakan curl dan simpan responsnya
RESPONSE=$(curl -s -X POST -F "key=${API_KEY}" -F "image=@${ABSOLUTE_IMAGE_PATH}" "${UPLOAD_URL}")

# Periksa apakah upload berhasil dengan memeriksa respons
if [[ $RESPONSE == *"\"success\":true"* ]]; then
  # Ekstrak URL dari respons
  URL=$(echo $RESPONSE | grep -oP '(?<="url":")[^"]+' | head -n 1 | sed 's/\\//g')
  
  # Modifikasi URL dengan menambahkan .com
  MODIFIED_URL=$(echo $URL | sed 's|https://i.ibb.co/|https://i.ibb.co.com/|')
  
  echo "link images: $MODIFIED_URL"
else
  echo "Upload gagal. Respons dari server: $RESPONSE"
fi
