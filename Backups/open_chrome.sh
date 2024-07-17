#!/bin/bash

# Nama jendela Google Chrome (sesuaikan jika perlu)
browser="google-chrome"

# Mencari jendela Google Chrome yang sedang berjalan
wmctrl -xa $browser || $browser &
