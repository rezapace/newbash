#!/bin/bash
NOTES_FILE="/home/r/Documents/Backups/notes.json"

# Cek apakah fzf dan jq sudah terinstal
if ! command -v fzf &> /dev/null || ! command -v jq &> /dev/null || ! command -v xclip &> /dev/null; then
    echo "Silakan instal fzf, jq, dan xclip terlebih dahulu."
    exit 1
fi

# Cek apakah file notes.json ada, jika tidak buat file kosong
if [ ! -f "$NOTES_FILE" ]; then
    echo "[]" > "$NOTES_FILE"
fi

# Fungsi untuk menambahkan notes
add_note() {
    read -p "Masukkan judul notes: " title
    read -p "Masukkan perintah notes: " command

    # Tambahkan note ke file JSON
    jq --arg title "$title" --arg command "$command" '. += [{"title": $title, "command": $command}]' "$NOTES_FILE" > tmp.$$.json && mv tmp.$$.json "$NOTES_FILE"
    
    echo "Notes '$title' berhasil ditambahkan."
}

# Fungsi untuk menghapus notes
delete_note() {
    # Pilih note untuk dihapus
    title=$(jq -r '.[] | .title' "$NOTES_FILE" | fzf --prompt="Pilih notes untuk dihapus: " --height=20% --border)
    
    if [ -n "$title" ]; then
        # Hapus note berdasarkan judul
        jq --arg title "$title" 'del(.[] | select(.title == $title))' "$NOTES_FILE" > tmp.$$.json && mv tmp.$$.json "$NOTES_FILE"
        echo "Notes '$title' berhasil dihapus."
    else
        echo "Tidak ada notes yang dipilih."
    fi
}

# Fungsi untuk mencari dan menyalin notes
search_note() {
    # Pilih note berdasarkan judul
    selected=$(jq -r '.[] | "\(.title): \(.command)"' "$NOTES_FILE" | fzf --prompt="Pilih notes untuk ditampilkan: " --height=20% --border)

    if [ -n "$selected" ]; then
        title=$(echo "$selected" | awk -F: '{print $1}')
        command=$(echo "$selected" | awk -F: '{print $2}')

        # Tampilkan detail notes
        echo "Judul: $title"
        echo "Perintah: $command"

        # Salin perintah ke clipboard
        echo "$command" | xclip -selection clipboard
        echo "Perintah '$command' telah disalin ke clipboard."
    else
        echo "Tidak ada notes yang dipilih."
    fi
}

# Fungsi untuk menampilkan menu utama
main_menu() {
    echo -e "Tambah Notes\nHapus Notes\nCari Notes" | fzf --prompt="Pilih aksi: " --height=20% --border
}

# Menu utama
action=$(main_menu)

case "$action" in
    "Tambah Notes")
        add_note
        ;;
    "Hapus Notes")
        delete_note
        ;;
    "Cari Notes")
        search_note
        ;;
    *)
        echo "Aksi tidak valid."
        exit 1
        ;;
esac
