#!/bin/bash
# Skrip untuk membuat file teks baru di direktori saat ini

# Dapatkan ID jendela aktif
active_window_id=$(xdotool getactivewindow)

# Dapatkan jalur direktori saat ini dari jendela Caja yang aktif
current_dir=$(xdotool getwindowname $active_window_id | sed 's/.* - //')

# Nama file teks baru
file_name="NewTextFile.txt"

# Buat file teks baru di direktori saat ini
touch "$current_dir/$file_name"

# Buka file teks baru dengan editor teks default (opsional)
xdg-open "$current_dir/$file_name"
