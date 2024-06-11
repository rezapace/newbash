#!/bin/bash

# Daftar program yang ingin dihentikan
killall chrome
killall code
killall wpsoffice
killall fliptext
killall wps
killall wpsoffi+
killall wpp

programs=(
    "chrome"
    "code"
    "wpsoffice"
    "fliptext"
    "wps"
    "wpsoffi+"
    "wpp"
)

# Melakukan iterasi pada setiap program
for program in "${programs[@]}"; do
    # Mencari PID dari proses program
    PID=$(pgrep "$program")
    
    # Menghentikan proses jika PID ditemukan
    if [ -n "$PID" ]; then
        kill "$PID"
        echo "Proses $program dengan PID $PID telah dihentikan."
    else
        echo "Tidak ada proses $program yang sedang berjalan."
    fi
done

