#!/bin/bash

# Nama jendela terminal (sesuaikan dengan nama terminal Anda, misalnya gnome-terminal)
terminal="mate-terminal"

# Mencari jendela terminal yang sedang berjalan
wmctrl -xa $terminal || $terminal &
