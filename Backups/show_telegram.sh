#!/bin/bash

# Fungsi untuk menampilkan jendela Telegram yang sudah ada atau memulai baru jika tidak ada
show_or_run_telegram() {
    # Mengecek apakah Telegram sudah berjalan
    if pgrep -f "telegram-desktop" > /dev/null; then
        # Menemukan proses Telegram yang sedang berjalan, tampilkan jendela yang sudah ada
        wmctrl -xa "telegram-desktop" || telegram-desktop &
    else
        # Jika tidak ada proses Telegram yang berjalan, jalankan Telegram baru
        telegram-desktop &
    fi
}

# Panggil fungsi untuk menampilkan atau menjalankan Telegram
show_or_run_telegram
