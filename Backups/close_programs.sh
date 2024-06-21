#!/bin/zsh

# Daftar program yang ingin dihentikan
programs=(
    "chrome"
    "code"
    "wpsoffice"
    "fliptext"
    "wps"
    "wpsoffi+"
    "wpp"
    "caja"
    "vlc"
    "libreoffice"
    "thunderbird"
    "xed"
)

# Fungsi untuk menampilkan pesan tanpa warna
function print_message {
    local message=$1
    local icon=$2
    echo "${icon} ${message}"
}

# Menghentikan semua program dalam daftar
for program in "${programs[@]}"; do
    if pkill "$program"; then
        print_message "Proses $program telah dihentikan." "✅"
    else
        print_message "Tidak ada proses $program yang sedang berjalan." "❌"
    fi
done
