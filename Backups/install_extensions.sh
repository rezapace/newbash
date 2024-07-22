#!/bin/bash

# Fungsi untuk memasang ekstensi di Chrome dari folder ekstensi
install_extension_from_folder() {
  EXTENSION_FOLDER=$1
  PROFILE_DIR=$2
  
  # Ambil nama folder ekstensi
  EXTENSION_ID=$(basename "$EXTENSION_FOLDER")
  
  # Direktori ekstensi di Chrome
  EXTENSION_DIR="$PROFILE_DIR/Extensions/$EXTENSION_ID"

  # Buat direktori tujuan jika belum ada
  mkdir -p "$EXTENSION_DIR"
  
  # Salin folder ekstensi ke direktori tujuan
  cp -r "$EXTENSION_FOLDER"/* "$EXTENSION_DIR/"

  echo "Ekstensi dari folder $EXTENSION_FOLDER telah dipasang di profil $PROFILE_DIR"
}

# Daftar folder ekstensi yang ingin dipasang
EXTENSION_FOLDERS=(
  "/home/r/github/extensi/extension"  # Ganti dengan path ke folder ekstensi kamu
)

# Direktori profil Chrome (default)
PROFILE_DIR="$HOME/.config/google-chrome/Default"

# Memasang semua ekstensi dari folder
for EXTENSION_FOLDER in "${EXTENSION_FOLDERS[@]}"; do
  install_extension_from_folder "$EXTENSION_FOLDER" "$PROFILE_DIR"
done

echo "Semua ekstensi dari folder telah berhasil dipasang."
