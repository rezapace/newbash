#!/bin/sh

# Sumber file dan folder
APPLICATIONS_DIR="/home/r/.local/share/applications/"
ZSH_CONFIG="/home/r/.zshrc"
BASH_CONFIG="/home/r/.bashrc"
BACKUPS="/home/r/Documents/Backups"

# Tujuan directory
DEST_DIR="/home/r/github/newbash"

# Membuat directory tujuan jika belum ada
mkdir -p "$DEST_DIR"

# Mengcopy folder applications
cp -r "$APPLICATIONS_DIR" "$DEST_DIR"

# Mengcopy file konfigurasi ZSH
cp "$ZSH_CONFIG" "$DEST_DIR"

# Mengcopy file konfigurasi Bash
cp "$BASH_CONFIG" "$DEST_DIR"

# mengcopy file scrip bachup.sh
cp -r "$BACKUPS" "$DEST_DIR"

echo "Semua file dan folder telah berhasil dicopy ke $DEST_DIR"

# Navigasi ke directory tujuan
cd "$DEST_DIR"

# Menambahkan perubahan ke Git
git add .

# Melakukan commit dengan pesan "update"
git commit -m "update"

# Melakukan push ke repository remote
git push

echo "Perubahan telah ditambahkan, di-commit, dan di-push ke repository Git"
