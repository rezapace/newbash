#!/bin/bash

# Pastikan argumen nama repository disediakan
if [ -z "$1" ]; then
  echo "Usage: gnew <nama-repository>"
  exit 1
fi

# Nama repository dari argumen pertama
nama_repo=$1

# Buat repository di GitHub dengan GitHub CLI Public
gh repo create $nama_repo --private --confirm

# Clone repository ke dalam folder /home/r/github
git clone https://github.com/rezapace/$nama_repo.git /home/r/github/$nama_repo

# Beritahu pengguna bahwa repository telah dibuat dan di-clone
echo "Repository $nama_repo berhasil dibuat di GitHub dan telah di-clone ke /home/r/github/$nama_repo."
