#!/bin/bash

# Menampilkan menu rofi dengan opsi
rofi -dmenu -p "Search for a directory:" -no-custom -i -lines 0 -width 30 << EOF
Run search
EOF

if [ "$?" -eq 0 ]; then
    # Jika opsi "Run search" dipilih, jalankan pencarian dengan fzf
    SELECTED_DIR=$(find "$HOME" -type d 2> /dev/null | fzf)

    if [ -n "$SELECTED_DIR" ]; then
        # Buka direktori yang dipilih menggunakan Caja
        caja "$SELECTED_DIR"
    else
        rofi -e "No directory selected."
    fi
fi
