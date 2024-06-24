#!/bin/bash

# Fungsi untuk menampilkan jendela Obsidian yang sudah ada atau memulai baru jika tidak ada
show_or_run_obsidian() {
    # Mengecek apakah Obsidian sudah berjalan
    if pgrep -f "Obsidian-1.6.3.AppImage" > /dev/null; then
        # Menemukan proses Obsidian yang sedang berjalan, tampilkan jendela yang sudah ada
        wmctrl -xa "Obsidian" || /opt/Obsidian-1.6.3.AppImage --no-sandbox &
    else
        # Jika tidak ada proses Obsidian yang berjalan, jalankan Obsidian baru
        /opt/Obsidian-1.6.3.AppImage --no-sandbox &
    fi
}

# Panggil fungsi untuk menampilkan atau menjalankan Obsidian
show_or_run_obsidian
