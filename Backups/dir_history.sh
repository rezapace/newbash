#!/bin/bash

# File untuk menyimpan riwayat direktori
HISTORY_FILE="$HOME/.dir_history"

# Menyimpan direktori saat ini ke dalam riwayat
save_dir_history() {
    pwd >> "$HISTORY_FILE"
    # Menjaga agar hanya menyimpan 100 riwayat terakhir
    tail -n 100 "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
}

# Menampilkan riwayat direktori dengan fzf dan cd ke direktori yang dipilih
go_back() {
    if [ ! -f "$HISTORY_FILE" ]; then
        echo "Riwayat direktori tidak ditemukan."
        return
    fi

    # Menampilkan 4 riwayat terakhir dengan fzf
    target_dir=$(tail -n 4 "$HISTORY_FILE" | fzf)

    # Jika direktori dipilih, pindah ke direktori tersebut
    if [ -n "$target_dir" ]; then
        cd "$target_dir" || echo "Gagal pindah ke direktori $target_dir"
    fi
}

# Argumen untuk menyimpan riwayat atau kembali ke direktori
case "$1" in
    save)
        save_dir_history
        ;;
    back)
        go_back
        ;;
    *)
        echo "Usage: $0 {save|back}"
        ;;
esac
