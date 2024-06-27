#!/bin/bash

# Nama jendela terminal (sesuaikan dengan nama terminal Anda, misalnya kitty)
terminal="kitty"

# Mencari jendela terminal yang sedang berjalan
wmctrl -xa $terminal || $terminal &